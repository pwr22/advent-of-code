package Advent::Intcode;

use strict;
use warnings;
use feature 'say';
use autodie;
use Const::Fast;
use English '-no_match_vars';
use Moo;
use MooX::StrictConstructor;
use MooX::HandlesVia;
use Types::Standard ':all';
use overload q{""} => \&as_str;
use Carp;
use namespace::autoclean;

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
    is  => 'ro',
    isa => FileHandle,
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

const my $ADD           => '01';
const my $MUL           => '02';
const my $INPUT         => '03';
const my $OUTPUT        => '04';
const my $JUMP_IF_TRUE  => '05';
const my $JUMP_IF_FALSE => '06';
const my $LESS_THAN     => '07';
const my $EQUALS        => '08';
const my $HALT          => '99';

const my $BINARY_INSTR_LENGTH       => 4;
const my $IO_INSTR_LENGTH           => 2;
const my $CONTROL_FLOW_INSTR_LENGTH => 3;

# Executes an Intcode until it completes.
#
# Throws exceptions on an unknown op code or overrunning memory without halting.
#
# TODO add debugging.
sub run {
    my $self = shift;

    while ( $self->_instr_ptr < $self->memory->@* ) {
        my $op = $self->memory->[ $self->_instr_ptr ];

        my ( $op_code, @param_modes ) = _decode_instr($op);

        # TODO move to dispatch table off the op code
        return if $op_code == $HALT;
        $self->_add(@param_modes),           next if $op_code == $ADD;
        $self->_mul(@param_modes),           next if $op_code == $MUL;
        $self->_input(@param_modes),         next if $op_code == $INPUT;
        $self->_output(@param_modes),        next if $op_code == $OUTPUT;
        $self->_jump_if_true(@param_modes),  next if $op_code == $JUMP_IF_TRUE;
        $self->_jump_if_false(@param_modes), next if $op_code == $JUMP_IF_FALSE;
        $self->_less_than(@param_modes),     next if $op_code == $LESS_THAN;
        $self->_equals(@param_modes),        next if $op_code == $EQUALS;

        croak "Unknown op code $op_code";
    }

    croak sprintf "instruction pointer %s has overrun the end of memory %s", $self->_instr_ptr,
      scalar $self->memory->@*;
}

const my $PARAM_POSITION_MODE  => 0;
const my $PARAM_IMMEDIATE_MODE => 1;

# Parses an instruction into the op code and parameter modes
sub _decode_instr {
    my $op = shift;

    my $expanded = sprintf "%05d", $op;
    my ( $par_3_mode, $par_2_mode, $par_1_mode, $op_code ) = $expanded =~ /^(\d)(\d)(\d)(\d\d)$/
      or croak "invalid operation $op";

    return $op_code, $par_1_mode, $par_2_mode, $par_3_mode;
}

sub _get_param {
    my ( $self, $num, $mode ) = @_;

    if ( $mode == $PARAM_POSITION_MODE ) {
        my $addr = $self->memory->[ $self->_instr_ptr + $num ];
        return $self->memory->[$addr];
    }
    elsif ( $mode == $PARAM_IMMEDIATE_MODE ) {
        return $self->memory->[ $self->_instr_ptr + $num ];
    }

    croak "invalid parameter mode $mode";
}

sub _set_param {
    my ( $self, $num, $mode, $val ) = @_;

    if ( $mode == $PARAM_POSITION_MODE ) {
        my $addr = $self->memory->[ $self->_instr_ptr + $num ];
        $self->memory->[$addr] = $val;
        return;
    }
    elsif ( $mode == $PARAM_IMMEDIATE_MODE ) {
        $self->memory->[ $self->_instr_ptr + $num ] = $val;
        return;
    }

    croak "invalid parameter mode $mode";
}

# TODO generalise the implementation of binary operators

# Executes an on the current Intcode state.
sub _add {
    my ( $self, $left_op_mode, $right_op_mode, $result_mode ) = @_;
    my ( $left, $right ) = ( $self->_get_param( 1, $left_op_mode ), $self->_get_param( 2, $right_op_mode ) );

    $self->_set_param( 3, $result_mode, $left + $right );
    $self->_inc_instr_ptr($BINARY_INSTR_LENGTH);

    return;
}

# Executes a multiply on the current Intcode state.
sub _mul {
    my ( $self, $left_op_mode, $right_op_mode, $result_mode ) = @_;
    my ( $left, $right ) = ( $self->_get_param( 1, $left_op_mode ), $self->_get_param( 2, $right_op_mode ) );

    $self->_set_param( 3, $result_mode, $left * $right );
    $self->_inc_instr_ptr($BINARY_INSTR_LENGTH);

    return;
}

# Executes an input instruction.
sub _input {
    my ( $self, $mode ) = @_;
    my $addr = $self->memory->[ $self->_instr_ptr + 1 ];

    my $fh  = $self->input;
    my $val = <$fh>;
    chomp($val);
    $self->_set_param( 1, $mode, $val );
    $self->_inc_instr_ptr($IO_INSTR_LENGTH);

    return;
}

# Executes an output instruction.
sub _output {
    my ( $self, $mode ) = @_;

    my $val = $self->_get_param( 1, $mode );

    my $fh = $self->output;
    say $fh $val or croak $!;
    $self->_inc_instr_ptr($IO_INSTR_LENGTH);

    return;
}

sub _is_true {
    my $val = shift;
    return $val != 0;
}

# Executes a jump if true instruction.
sub _jump_if_true {
    my ( $self, $cond_mode, $trgt_mode ) = @_;
    my ( $cond, $trgt ) = ( $self->_get_param( 1, $cond_mode ), $self->_get_param( 2, $trgt_mode ) );

    if ( _is_true($cond) ) {
        $self->_instr_ptr($trgt);
    }
    else {
        $self->_inc_instr_ptr($CONTROL_FLOW_INSTR_LENGTH);
    }

    return;
}

# Executes a jump if false instruction.
sub _jump_if_false {
    my ( $self, $cond_mode, $trgt_mode ) = @_;
    my ( $cond, $trgt ) = ( $self->_get_param( 1, $cond_mode ), $self->_get_param( 2, $trgt_mode ) );

    if ( not _is_true($cond) ) {
        $self->_instr_ptr($trgt);
    }
    else {
        $self->_inc_instr_ptr($CONTROL_FLOW_INSTR_LENGTH);
    }

    return;
}

# Executes a less than instruction.
sub _less_than {
    my ( $self, $left_mode, $right_mode, $result_mode ) = @_;
    my ( $left, $right ) = ( $self->_get_param( 1, $left_mode ), $self->_get_param( 2, $right_mode ) );

    my $val = $left < $right ? 1 : 0;
    $self->_set_param( 3, $result_mode, $val );
    $self->_inc_instr_ptr($BINARY_INSTR_LENGTH);

    return;
}

# Executes an equals instruction.
sub _equals {
    my ( $self, $left_mode, $right_mode, $result_mode ) = @_;
    my ( $left, $right ) = ( $self->_get_param( 1, $left_mode ), $self->_get_param( 2, $right_mode ) );

    my $val = $left == $right ? 1 : 0;
    $self->_set_param( 3, $result_mode, $val );
    $self->_inc_instr_ptr($BINARY_INSTR_LENGTH);

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
            # TODO use this object and reset it each time
            my $sim = Advent::Intcode->new( state => $self->initial_state );
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
