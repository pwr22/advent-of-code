package Advent::OrbitMap::Object;

use strict;
use warnings;
use Moo;
use MooX::StrictConstructor;
use MooX::HandlesVia;
use Types::Standard qw( HashRef InstanceOf );

has 'name' => (
    is       => 'ro',
    required => 1,
);

has 'orbits' => (
    is       => 'rw',
    isa      => InstanceOf ['Advent::OrbitMap::Object'],
);

has 'orbited_by' => (
    is          => 'rw',
    isa         => HashRef,
    default     => sub { {} },
    handles_via => 'Hash',
    handles     => {
        add_orbiter   => 'add',
        is_orbited_by => 'get',
        get_orbiters  => 'values',
    },
);

sub get_total_orbits {
    my $self = shift;

    return 0 unless defined $self->orbits;

    # direct + indirect
    return 1 + $self->orbits->get_total_orbits();
}

1;
