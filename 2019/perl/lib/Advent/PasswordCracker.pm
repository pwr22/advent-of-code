package Advent::PasswordCracker;

use strict;
use warnings;
use autodie;
use Const::Fast;
use Moo;
use MooX::HandlesVia;
use Types::Standard ':all';
use Types::Common::Numeric ':all';
use Advent::PasswordCracker::Types ':all';
use Carp;

has [qw[ start end ]] => (
    is       => 'ro',
    isa      => PositiveOrZeroInt,
    required => 1,
);

# Find and return the count of all valid password candidates
sub get_candidate_count {
    my $self = shift;

    my $count = 0;
    for my $candid ( $self->start .. $self->end ) {
        $count++ if Password->check($candid);
    }

    return $count;
}

# Find and return the count of all valid revised password candidates
sub get_revised_candidate_count {
    my $self = shift;

    my $count = 0;
    for my $candid ( $self->start .. $self->end ) {
        $count++ if RevisedPassword->check($candid);
    }

    return $count;
}

1;
