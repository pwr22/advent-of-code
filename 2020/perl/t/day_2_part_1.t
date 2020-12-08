#!/usr/bin/perl

use strict;
use warnings;
use Const::Fast;
use Test::More tests => 3;

use Advent::2020::Password::Policy;

const my @INPUTS => ( '1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc', );

my @pols = map { Advent::2020::Password::Policy->new( policy => $_ ) } @INPUTS;

ok( $pols[0]->is_valid,  'password 1 is valid' );
ok( !$pols[1]->is_valid, 'password 2 is invalid' );
ok( $pols[2]->is_valid,  'password 3 is valid' );

