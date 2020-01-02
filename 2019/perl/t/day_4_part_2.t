#!/usr/bin/perl

use strict;
use warnings;
use experimental 'declared_refs';
use feature 'declared_refs';
use Test::More tests => 1;

use Advent::PasswordCracker;
use Advent::Input;

# [ <RANGE_START> <RANGE_END> [ <EXP_PASSWORDS> ] ]
my @testcases = ( [ $Advent::Input::DAY_4_RANGE_START, $Advent::Input::DAY_4_RANGE_END, 1291 ], );

for (@testcases) {
    my ( $start, $end, $exp ) = $_->@*;
    my $cracker = Advent::PasswordCracker->new( start => $start, end => $end );
    is( $cracker->get_revised_candidate_count(), $exp );
}
