#!/usr/bin/perl

use strict;
use warnings;
use autodie;

sub calc_fuel {
    my $mass = shift;
    return int( $mass / 3 ) - 2;
}

sub calc_total_fuel {
    my @masses = @_;
    my $total  = 0;
    for (@masses) {
        my $fuel = calc_fuel($_);
        $total += $fuel;

        while ( ( $fuel = calc_fuel($fuel) ) > 0 ) {
            $total += $fuel;
        }
    }

    return $total;
}

open my $inputs, '<', 'input.txt';
my @inputs = <$inputs>;
close $inputs;

my $total = calc_total_fuel(@inputs);
print "$total\n";
