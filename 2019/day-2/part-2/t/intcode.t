#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 6;

use Advent::Intcode;
use Advent::Input;

# [ <INPUT_INTCODE>, <OUTPUT_INTCODE> ]
my @testcases = (
    [ '1,0,0,0,99',          '2,0,0,0,99' ],
    [ '2,3,0,3,99',          '2,3,0,6,99' ],
    [ '2,4,4,5,99,0',        '2,4,4,5,99,9801' ],
    [ '1,1,1,4,99,5,6,0,99', '30,1,1,4,2,5,6,0,99' ],
);

for (@testcases) {
    my ( $start_state, $exp_state ) = $_->@*;
    my $sim = Advent::Intcode->new( state => $start_state );
    $sim->run();
    is( $sim->as_str(), $exp_state );
}

# [ <INTCODE> <DESIRED_OUTPUT> <TARGET_NOUN> <TARGET_VERB> ]
@testcases = ( [ $Advent::Input::DAY_2, 19690720, 57, 41 ], );

for (@testcases) {
    my ( $start_state, $output, $exp_noun, $exp_verb ) = $_->@*;
    my $sim = Advent::Intcode->new( state => $start_state );
    my ( $noun, $verb ) = $sim->find_inputs_for($output);
    is( $noun, $exp_noun );
    is( $verb, $exp_verb );
}
