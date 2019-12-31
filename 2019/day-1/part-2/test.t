#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 7;

do './solution.pl';

# calc_fuel_for_mod
for ([12,2], [14,2], [1969,654], [100756,33583]) {
    is(calc_fuel($_->[0]), $_->[1]);
}

# calc_total_fuel
for ([14, 2], [1969, 966], [100756, 50346]) {
    is(calc_total_fuel($_->[0]), $_->[1]);   
}