package Advent::Intcode;

use strict;
use warnings;
use autodie;
use Const::Fast;
use English '-no_match_vars';
use Moo;
use MooX::StrictConstructor;
use MooX::HandlesVia;
use Types::Standard ':all';
use overload q{""} => \&as_str;
use Carp;

use Advent::Input;

our $VERSION = v0.0.1;

has 'initial_state' => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    init_arg => 'state',
);

has 'memory' => (
    is          => 'lazy',
    isa         => ArrayRef,
    handles_via => 'Array',
    handles     => {
        get_address => 'get',
        set_address => 'set',
    }
);

has [qw[ input output ]] => (
    is      => 'ro',
    isa     => ArrayRef,
    default => sub { [] },
);

has '_instr_ptr' => (
    is      => 'rw',
    isa     => Int,
    default => 0,
);

sub _inc_instr_ptr {
    my ( $self, $amount ) = @_;
    $self->_instr_ptr( $self->_instr_ptr + $amount );
    return;
}

sub _build_memory {
    my $self = shift;
    my $s    = $self->initial_state;
    my @code = split q{,}, $s;
    chomp @code;
    return \@code;
}

const my $ADD    => 1;
const my $MUL    => 2;
const my $INPUT  => 3;
const my $OUTPUT => 4;
const my $HALT   => 99;

const my $BINARY_OP_LENGTH => 4;
const my $IO_OP_LENGTH     => 2;

# Executes an Intcode until it completes.
#
# Throws exceptions on an unknown op code or overrunning memory without halting.
#
# TODO add debugging.
sub run {
    my $self = shift;

    while ( $self->_instr_ptr < $self->memory->@* ) {
        my $op = $self->memory->[ $self->_instr_ptr ];

        # TODO move to dispatch table off the op code
        return if $op == $HALT;
        $self->_add(),    next if $op == $ADD;
        $self->_mul(),    next if $op == $MUL;
        $self->_input(),  next if $op == $INPUT;
        $self->_output(), next if $op == $OUTPUT;

        croak "Unknown op code $op";
    }

    croak "instruction pointer has overrun the end of memory";
}

# TODO generalise the implementation of binary operators

# Executes an on the current Intcode state.
sub _add {
    my $self = shift;

    my ( $addr_1, $addr_2, $result_addr ) =
      $self->memory->@[ $self->_instr_ptr + 1 .. $self->_instr_ptr + $BINARY_OP_LENGTH ];
    my ( $val_1, $val_2 ) = $self->memory->@[ $addr_1, $addr_2 ];
    $self->memory->[$result_addr] = $val_1 + $val_2;

    # increment the intstruction pointer
    $self->_inc_instr_ptr($BINARY_OP_LENGTH);

    return;
}

# Executes a multiply on the current Intcode state.
sub _mul {
    my $self = shift;

    my ( $addr_1, $addr_2, $result_addr ) =
      $self->memory->@[ $self->_instr_ptr + 1 .. $self->_instr_ptr + $BINARY_OP_LENGTH ];
    my ( $val_1, $val_2 ) = $self->memory->@[ $addr_1, $addr_2 ];
    $self->memory->[$result_addr] = $val_1 * $val_2;

    # increment the intstruction pointer
    $self->_inc_instr_ptr($BINARY_OP_LENGTH);

    return;
}

# Executes an input instruction.
sub _input {
    my $self = shift;
    my $addr = $self->memory->[ $self->_instr_ptr + 1 ];

    my $input = shift $self->input->@*;
    $self->memory->[$addr] = $input;

    $self->_inc_instr_ptr($IO_OP_LENGTH);

    return;
}

# Executes an output instruction.
sub _output {
    my $self = shift;
    my $addr = $self->memory->[ $self->_instr_ptr + 1 ];

    my $val = $self->memory->[$addr];
    push $self->output->@*, $val;

    $self->_inc_instr_ptr($IO_OP_LENGTH);

    return;
}

# Returns a string representation of the current Intcode state.
sub as_str {
    my $self = shift;
    return join q{,}, $self->memory->@*;
}

sub set_noun {
    my ( $self, $val ) = @_;
    return $self->set_address( 1, $val );
}

sub set_verb {
    my ( $self, $val ) = @_;
    return $self->set_address( 2, $val );
}

sub get_output {
    my $self = shift;
    return $self->get_address(0);
}

const my $MIN_FIND_VALUE => 0;
const my $MAX_FIND_VALUE => 99;

# Searches or an returns an input noun and verb which produce a given output value.
sub find_inputs_for {
    my ( $self, $output ) = @_;

    for my $noun ( $MIN_FIND_VALUE .. $MAX_FIND_VALUE ) {
        for my $verb ( $MIN_FIND_VALUE .. $MAX_FIND_VALUE ) {
            my $sim = Advent::Intcode->new( state => $Advent::Input::DAY_2 );
            $sim->set_noun($noun);
            $sim->set_verb($verb);
            $sim->run();

            if ( $sim->get_output() == $output ) {
                return $noun, $verb;
            }
        }
    }

    croak
"could not find inputs giving output $output inside search range of $MIN_FIND_VALUE to $MAX_FIND_VALUE inclusive.";
}

1;
