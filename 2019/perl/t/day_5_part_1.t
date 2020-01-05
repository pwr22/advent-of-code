#!/usr/bin/perl

use strict;
use warnings;
use experimental 'declared_refs';
use feature 'declared_refs';
use Test::More tests => 2;

use Advent::Intcode;
use Advent::Input;

# [ <INITIAL_STATE> [ <INPUTS> ] [ <EXP_OUTPUTS> ] ]
my @testcases =
  ( [ '3,0,4,0,99', "27\n", "27\n" ], [ $Advent::Input::DAY_5, "1\n", "0\n0\n0\n0\n0\n0\n0\n0\n0\n7259358\n", ] );

for (@testcases) {
    my ( $state, $input, $exp_output ) = $_->@*;

    open my $ifh, '<', \$input;
    my $output = '';
    open my $ofh, '>', \$output;
    my $sim = Advent::Intcode->new( state => $state, input => $ifh, output => $ofh );
    $sim->run();
    is( $output, $exp_output );
}
