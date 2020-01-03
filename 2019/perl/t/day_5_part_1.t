#!/usr/bin/perl

use strict;
use warnings;
use experimental 'declared_refs';
use feature 'declared_refs';
use Test::More tests => 1;

use Advent::Intcode;
use Advent::Input;

# [ <INITIAL_STATE> [ <INPUTS> ] [ <EXP_OUTPUTS> ] ]
my @testcases = ( [ '3,0,4,0,99', [27], [27] ] );

for (@testcases) {
    my ( $state, \@inputs, \@exp_outputs ) = $_->@*;
    my $sim = Advent::Intcode->new( state => $state, input => \@inputs );
    $sim->run();
    is_deeply( $sim->output, \@exp_outputs );
}
