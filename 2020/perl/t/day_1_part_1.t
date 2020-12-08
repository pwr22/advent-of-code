#!/usr/bin/perl

use strict;
use warnings;
use Const::Fast;
use Test::More tests => 2;

use Advent::2020::ExpenseReport;

const my @ENTRIES => qw(
  1721
  979
  366
  299
  675
  1456
);
const my @PAIR    => qw(1721 299);
const my $PRODUCT => 514579;

my $r = Advent::2020::ExpenseReport->new( entries => \@ENTRIES );

is_deeply(
    [ sort $r->_find_2020_pair() ],
    [ sort @PAIR ],
    'correct pair summing to 2020 is found'
);

is( $r->find_2020_pair_product(),
    $PRODUCT, 'correct product of pair summing to 2020 is found' );
