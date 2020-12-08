package Advent::2020::ExpenseReport;

use strict;
use warnings;
use autodie;
use Const::Fast;
use Carp;
use Moo;
use Types::Standard qw( :all );

has entries => (
    is       => 'ro',
    isa      => ArrayRef,
    required => 1,
);

# find the two entries summing to 2020
sub _find_2020_pair {
    my ($self) = @_;

    for my $n ( $self->entries->@* ) {
        for my $m ( $self->entries->@* ) {
            return $n, $m if $n + $m == 2020;
        }
    }

    croak "cannot find any entries summing to 2020";
}

# return product of the two entries summing to 2020
sub find_2020_product {
    my ($self) = @_;

    my ($n, $m) = $self->_find_2020_pair();

    return $n * $m;
}

use namespace::autoclean;
1;
