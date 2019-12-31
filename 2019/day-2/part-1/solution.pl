#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use DDP;
use Const::Fast;
use feature qw(postderef);

sub parse_intcode_file {
    my $f = shift;
    open my $fh, '<', $f;

    local $/ = ',';
    my @code = <$fh>;
    chomp @code;

    close $fh;
    return \@code;
}

const my $ADD => 1;
const my $MUL => 2;
const my $HLT => 3;

sub run_intcode {
    my $code = shift;
    my $pos  = 0;

    while ( $pos < $code->@* ) {
        my ( $op, @args ) = $code->@[ $pos .. $pos + 4 ];

        last                    if $op == $HLT;
        run_add( $code, @args ) if $op == $ADD;
        run_mul( $code, @args ) if $op == $MUL;

        # goto the next instruction
        $pos += 4;
    }
}

sub run_add {
    my ( $code, $op_1, $op_2, $store ) = @_;

#     print
# "adding $op_1:$code->[$op_1] and $op_2:$code->[$op_2] and storing in $store\n";

    $code->[$store] = $code->[$op_1] + $code->[$op_2];
}

sub run_mul {
    my ( $code, $op_1, $op_2, $store ) = @_;

#     print
# "multiplying $op_1:$code->[$op_1] and $op_2:$code->[$op_2] and storing in $store\n";

    $code->[$store] = $code->[$op_1] * $code->[$op_2];
}

sub print_code {
    my $code = shift;
    print join( ',', $code->@* ), "\n";
}


my $code = parse_intcode_file('input.txt');

# apply previous state
$code->[1] = 12;
$code->[2] = 2;

run_intcode($code);
print "$code->[0]\n"
