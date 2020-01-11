#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;

use Advent::OrbitMap;

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
);

for (@testcases) {
    my ( $spec, $exp_orbits ) = $_->@*;
    my $m = Advent::OrbitMap->new( spec => $spec );
    is( $m->get_total_orbits(), $exp_orbits );
}
