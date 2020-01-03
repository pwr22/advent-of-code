#!/usr/bin/perl

use strict;
use warnings;
use experimental 'declared_refs';
use feature 'declared_refs';
use Test::More tests => 2;

use Advent::OrbitMap;
use Advent::Input;

# [ <ORBIT_MAP_SPEC> <EXP_TOTAL_ORBITS> ]
my @testcases = (
    [
        'COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L', 42
    ],
    [ $Advent::Input::DAY_6, 314247 ],
);

for (@testcases) {
    my ( $spec, $exp_orbits ) = $_->@*;
    my $m = Advent::OrbitMap->new( spec => $spec );
    is( $m->get_total_orbits(), $exp_orbits );
}
