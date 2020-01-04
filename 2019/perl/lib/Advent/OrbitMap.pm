package Advent::OrbitMap;

use strict;
use warnings;
use feature 'say';
use Moo;
use MooX::StrictConstructor;
use MooX::HandlesVia;
use Types::Standard qw( Str HashRef);
use Carp;
use Scalar::Util qw( weaken );

use Advent::OrbitMap::Object;

has 'spec' => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has 'objects' => (
    is          => 'lazy',
    isa         => HashRef,
    handles_via => 'Hash',
    handles     => {
        get_object => 'get',
    },
);

sub _build_objects {
    my $self = shift;

    my @orbits = split /\n/, $self->spec;
    chomp @orbits;

    my %objects;
    for (@orbits) {
        my ( $orbited, $orbiter ) = /^(\w+)\)(\w+)$/ or croak "Invalid orbit specification $_";

        # say "$orbiter orbits $orbited";

        $objects{$orbited} //= Advent::OrbitMap::Object->new( name => $orbited );
        $objects{$orbiter} //= Advent::OrbitMap::Object->new( name => $orbiter );

        # TODO Only use strings as references - keep state in the map.
        $objects{$orbiter}->orbits( $objects{$orbited} );
        $objects{$orbited}->add_orbiter( $orbiter, $objects{$orbiter} );    # makes a circular reference but who cares
    }

    return \%objects;
}

sub get_total_orbits {
    my $self = shift;

    # TODO Do this functionally.
    my $total = 0;

    for my $object ( values $self->objects->%* ) {
        $total += $object->get_total_orbits;
    }

    return $total;
}

sub get_orbital_transfers {
    my ( $self, $origin, $dest ) = @_;

    my $o = $self->objects->{$origin} or croak "No origin $origin";
    my $d = $self->objects->{$dest}   or croak "No destination $dest";

    my @p = map { $_->name } $o->get_shortest_path($d);
    shift @p;    # we are the origin
    shift @p;    # we are already in orbit of this
    pop @p;      # we don't need to orbit the destination, just what it orbits

    return scalar @p;
}

1;
