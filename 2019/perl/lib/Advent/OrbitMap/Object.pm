package Advent::OrbitMap::Object;

use strict;
use warnings;
use Moo;
use MooX::StrictConstructor;
use MooX::HandlesVia;
use Types::Standard qw( HashRef );

has 'name' => (
    is       => 'ro',
    required => 1,
);

has 'orbits' => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { {} },
);

sub get_total_orbits {
    my $self = shift;

    my $total = 0;

    for my $object ( values $self->orbits->%* ) {
        $total += 1;                            # the direct orbit
        $total += $object->get_total_orbits;    # indirect orbits
    }

    return $total;
}

1;
