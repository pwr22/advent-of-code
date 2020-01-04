#!/usr/bin/perl

use strict;
use warnings;
use experimental 'declared_refs';
use feature 'declared_refs';
use Test::More tests => 2;

use Advent::OrbitMap;
use Advent::Input;

# [ <ORBIT_MAP_SPEC> <ORIGIN> <DEST> <EXP_ORB_XFERS> ]
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
K)L
K)YOU
I)SAN
', 'YOU', 'SAN', 4
    ],

    [ $Advent::Input::DAY_6, 'YOU', 'SAN', 514 ],
);

for (@testcases) {
    my ( $spec, $origin, $dest, $exp_orbits ) = $_->@*;
    my $m = Advent::OrbitMap->new( spec => $spec );
    is( $m->get_orbital_transfers( $origin, $dest ), $exp_orbits );
}
