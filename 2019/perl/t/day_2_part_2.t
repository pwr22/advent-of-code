#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 2;

use Advent::Intcode;
use Advent::Input;

# [ <INTCODE> <DESIRED_OUTPUT> <TARGET_NOUN> <TARGET_VERB> ]
my @testcases = ( [ $Advent::Input::DAY_2, 19690720, 57, 41 ], );

for (@testcases) {
    my ( $start_state, $output, $exp_noun, $exp_verb ) = $_->@*;
    my $sim = Advent::Intcode->new( state => $start_state );
    my ( $noun, $verb ) = $sim->find_inputs_for($output);
    is( $noun, $exp_noun );
    is( $verb, $exp_verb );
}
