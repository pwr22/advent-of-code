#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 4;

do './solution.pl';

for ([12,2], [14,2], [1969,654], [100756,33583]) {
    is(calc_fuel($_->[0]), $_->[1]);
}