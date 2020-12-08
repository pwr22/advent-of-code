#!/usr/bin/env perl

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
const my @TRIPLET    => qw(979 366 675);
const my $PRODUCT => 241861950;

my $r = Advent::2020::ExpenseReport->new( entries => \@ENTRIES );

is_deeply(
    [ sort $r->_find_2020_triplet() ],
    [ sort @TRIPLET ],
    'correct triplet summing to 2020 is found'
);

is( $r->find_2020_triplet_product(),
    $PRODUCT, 'correct product of triplet summing to 2020 is found' );
