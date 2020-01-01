package Advent::Intcode;

use strict;
use warnings;
use autodie ':all';
use Const::Fast;
use English '-no_match_vars';

use Advent::Input;

our $VERSION = v0.0.1;

sub parse_input {
    return parse_intcode_str($Advent::Input::INPUT);
}

sub parse_intcode_str {
    my $s    = shift;
    my @code = split ',', $s;
    chomp @code;
    return \@code;
}

const my $ADD => 1;
const my $MUL => 2;
const my $HLT => 3;

const my $INSTR_LENGTH => 4;

sub run_intcode {
    my $code = shift;
    my $pos  = 0;

    while ( $pos < $code->@* ) {
        my ( $op, @args ) = $code->@[ $pos .. $pos + 4 ];

        last                    if $op == $HLT;
        run_add( $code, @args ) if $op == $ADD;
        run_mul( $code, @args ) if $op == $MUL;

        $pos += $INSTR_LENGTH;
    }

    return;
}

sub run_add {
    my ( $code, $op_1, $op_2, $store ) = @_;
    $code->[$store] = $code->[$op_1] + $code->[$op_2];
    return;
}

sub run_mul {
    my ( $code, $op_1, $op_2, $store ) = @_;
    $code->[$store] = $code->[$op_1] * $code->[$op_2];
    return;
}

sub run_main {
    my $code = parse_intcode_file('input.txt');

    # apply previous state
    $code->[1] = 12;
    $code->[2] = 2;

    run_intcode($code);
    print "$code->[0]\n" or die $!;
}

1;
