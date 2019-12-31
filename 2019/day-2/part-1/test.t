#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 4;

do './solution.pl';

# [ <INPUT_INTCODE>, <OUTPUT_INTCODE> ]
my @testcases = (
    [
        [1,0,0,0,99], [2,0,0,0,99]
    ],
    [
        [2,3,0,3,99], [2,3,0,6,99]
    ],
    [
        [2,4,4,5,99,0], [2,4,4,5,99,9801]
    ],
    [
        [1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99]
    ],
);

for (@testcases) {
    my ($in_state, $exp_state) = $_->@*;
    run_intcode($in_state);
    is_deeply($in_state,$exp_state);
}