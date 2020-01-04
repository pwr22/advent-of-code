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
    is  => 'lazy',
    isa => HashRef,
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

        $objects{$orbiter}->orbits($objects{$orbited});
    }

    return \%objects;
}


sub get_total_orbits {
    my $self = shift;

    my $total = 0;

    for my $object ( values $self->objects->%* ) {
        $total += $object->get_total_orbits;
    }

    return $total;
}

1;
