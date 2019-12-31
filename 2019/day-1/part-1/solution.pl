#!/usr/bin/perl

use strict;
use warnings;
use autodie;

sub calc_fuel {
    my $mass = shift;
    return int($mass / 3) - 2;
}

open my $inputs, '<', 'input.txt';
my $total = 0;
while(<$inputs>) {
    $total += calc_fuel($_);
}
close $inputs;

print "$total\n";