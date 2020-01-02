package Advent::Panel::Location;

use strict;
use warnings;
use autodie;
use Const::Fast;
use Moo;
use MooX::HandlesVia;
use Types::Standard ':all';
use List::Util qw( sum );

use overload (
    '-' => sub {
        my ( $self, $other ) = @_;
        return abs( $self->x - $other->x ) + abs( $self->y - $other->y );
    },
    '""' => sub {
        my $self = shift;
        return sprintf "(%s, %s)", $self->x, $self->y;
    },
);

use Carp;

has [qw[ x y ]] => (
    is       => 'ro',
    isa      => Num,
    required => 1,
);

has '_wires' => (
    is          => 'ro',
    handles_via => 'Hash',
    default     => sub { {} },
    handles     => {
        '_wires_present' => 'count',
    },
);

sub add_wire {
    my ( $self, $id, $steps ) = @_;

    # Keep the earlier steps if we've already been here.
    return if exists $self->_wires->{$id};
    
    $self->_wires->{$id} = $steps;
    return;
}

sub is_intersection {
    my $self = shift;
    return $self->_wires_present >= 2;
}

sub total_steps {
    my $self = shift;
    return sum values $self->_wires->%*;
}

1;
