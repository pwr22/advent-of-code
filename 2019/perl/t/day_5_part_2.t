#!/usr/bin/perl

use strict;
use warnings;
use experimental 'declared_refs';
use feature 'declared_refs';
use Test::More tests => 14;

use Advent::Intcode;
use Advent::Input;

# [ <INITIAL_STATE> <INPUT> <EXP_OUTPUT> ]
my @testcases = (

    # 1 if == 8, 0 otherwise with position mode
    [ '3,9,8,9,10,9,4,9,99,-1,8', "8\n", "1\n" ],
    [ '3,9,8,9,10,9,4,9,99,-1,8', "7\n", "0\n" ],

    # 1 if < 8, 0 otherwise with position mode
    [ '3,9,7,9,10,9,4,9,99,-1,8', "7\n", "1\n" ],
    [ '3,9,7,9,10,9,4,9,99,-1,8', "8\n", "0\n" ],

    # 1 if == 8, 0 otherwise with immediate mode
    [ '3,3,1108,-1,8,3,4,3,99', "8\n", "1\n" ],
    [ '3,3,1108,-1,8,3,4,3,99', "7\n", "0\n" ],

    # 1 if < 8, 0 otherwise with immediate mode
    [ '3,3,1107,-1,8,3,4,3,99', "7\n", "1\n" ],
    [ '3,3,1107,-1,8,3,4,3,99', "8\n", "0\n" ],

    # 0 if == 0, 1 otherwise
    [ '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9', "0\n", "0\n" ],
    [ '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9', "1\n", "1\n" ],

    # 999 if < 8, 1000 if == 8 and 1001 if > 8
    [
'3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99',
        "7\n",
        "999\n"
    ],
    [
'3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99',
        "8\n",
        "1000\n"
    ],
    [
'3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99',
        "9\n",
        "1001\n"
    ],

    # the task
    [ $Advent::Input::DAY_5, "5\n", "11826654\n" ],
);

for (@testcases) {
    my ( $state, $input, $exp_output ) = $_->@*;

    open my $ifh, '<', \$input;
    my $output = '';
    open my $ofh, '>', \$output;
    my $sim = Advent::Intcode->new( state => $state, input => $ifh, output => $ofh );
    $sim->run();
    is_deeply( $output, $exp_output );
}
