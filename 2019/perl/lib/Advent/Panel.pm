package Advent::Panel;

use strict;
use warnings;
use autodie;
use Const::Fast;
use Moo;
use Carp;
use Types::Standard ':all';
use List::Util qw( min );
use Data::GUID;
use feature 'say';

use Advent::Panel::Location;

our $VERSION = v0.0.1;

has '_port' => (
    is      => 'ro',
    default => sub {
        Advent::Panel::Location->new(
            x => 0,
            y => 0,
        );
    }
);

has '_grid' => (
    is      => 'ro',
    default => sub { {} },
);

# Get a count of the cables present at location $x, $y
sub _get_loc {
    my ( $self, $x, $y ) = @_;
    my $k = "$x,$y";

    $self->_grid->{$k} = Advent::Panel::Location->new( x => $x, y => $y )
      if not exists $self->_grid->{$k};

    return $self->_grid->{$k};
}

# Takes a wire specification and adds it to the panel
sub add_wire {
    my ( $self, $spec ) = @_;
    my $id = Data::GUID->new()->as_string();    # just has to be different for each wire

    my ( $x, $y, $steps ) = ( $self->_port->x, $self->_port->y, 0 );
    my @runs = split /,/, $spec;
    for (@runs) {
        my ( $dir, $len ) = $_ =~ /^([UDLR])(\d+)$/ or croak "invalid wire piece $_ in $spec";

        for ( 1 .. $len ) {

            $y++ if $dir eq 'U';
            $y-- if $dir eq 'D';
            $x++ if $dir eq 'R';
            $x-- if $dir eq 'L';
            $steps++;

            $self->_get_loc( $x, $y )->add_wire( $id, $steps );
        }

    }

    return;
}

sub get_closest_intersect_distance {
    my $self = shift;

    my @intrsects = grep { $_->is_intersection() } values $self->_grid->%*
      or croak 'there are no isects';

    return min map { $_ - $self->_port } @intrsects;
}

sub get_shortest_intersect_steps {
    my $self = shift;

    my @intrsects = grep { $_->is_intersection() } values $self->_grid->%*
      or croak 'there are no isects';

    return min map { $_->total_steps } @intrsects;
}

1;
