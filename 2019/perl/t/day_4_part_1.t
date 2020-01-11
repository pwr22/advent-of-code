#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;

use Advent::PasswordCracker;

my ( $start, $end, $exp ) = qw( 136818 685979 1919 );
my $cracker = Advent::PasswordCracker->new( start => $start, end => $end );
is( $cracker->get_candidate_count(), $exp );
