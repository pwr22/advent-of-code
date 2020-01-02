#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 2;

use Advent::Panel;
use Advent::Input;

# [ <WIRE_1> <WIRE_2> <EXP_STEPS> ]
my @testcases = (
    [ 'R75,D30,R83,U83,L12,D49,R71,U7,L72',          'U62,R66,U55,R34,D71,R55,D58,R83',      610 ],
    [ 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51', 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7', 410 ],
);

for (@testcases) {
    my ( $w1, $w2, $exp_d ) = $_->@*;
    my $panel = Advent::Panel->new();
    $panel->add_wire($w1);
    $panel->add_wire($w2);
    is( $panel->get_shortest_intersect_steps(), $exp_d );
}
