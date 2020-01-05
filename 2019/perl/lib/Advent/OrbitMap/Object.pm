package Advent::OrbitMap::Object;

use strict;
use warnings;
use Moo;
use MooX::StrictConstructor;
use MooX::HandlesVia;
use Types::Standard qw( HashRef InstanceOf );
use Carp;
use Try::Tiny;

# use namespace::autoclean;

has 'name' => (
    is       => 'ro',
    required => 1,
);

has 'orbits' => (
    is        => 'rw',
    isa       => InstanceOf ['Advent::OrbitMap::Object'],
    predicate => 'does_orbit',
);

has 'orbited_by' => (
    is          => 'rw',
    isa         => HashRef [ InstanceOf ['Advent::OrbitMap::Object'] ],
    default     => sub { {} },
    handles_via => 'Hash',
    handles     => {
        add_orbiter   => 'set',
        is_orbited_by => 'get',
        get_orbiters  => 'values',
    },
);

sub get_total_orbits {
    no warnings 'recursion';

    my $self = shift;

    return 0 unless defined $self->orbits;

    # direct + indirect
    return 1 + $self->orbits->get_total_orbits();
}

sub get_shortest_path {
    no warnings 'recursion';

    my ( $self, $dest, $skip ) = @_;

    return $self if $self == $dest;    # don't need to go anywhere if we're already there!

    # build a list of candidates
    my @cands = $self->get_orbiters;
    unshift @cands, $self->orbits if $self->does_orbit;
    @cands = grep { $_ != $skip } @cands if defined $skip;    # don't look back where we're coming from - prevents loops

    my @shortest;
    for my $o (@cands) {
        try {
            my @p = ( $self, $o->get_shortest_path( $dest, $self ) );
            @shortest = @p if @shortest == 0 || @p < @shortest;
        };
    }

    croak sprintf "No path to %s", $dest->name
      unless @shortest;

    return @shortest;
}

1;
