package Advent::2020::Password::Policy2;

use strict;
use warnings;
use autodie;
use Const::Fast;
use Carp;
use Moo;
use Types::Standard qw( :all );

has policy => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has [qw[ _loc_1 _loc_2]] => (
    is  => 'rwp',
    isa => Int,
);

has [qw[ _letter _password ]] => (
    is  => 'rwp',
    isa => Str,
);

# min_freq, max_freq, letter, password
const my $POL_REGEX => qr/^(\d+)-(\d+) (\w): (\w+)$/;

# populate other attributers from the policy string
around BUILDARGS => sub {
    my ( $orig, $class, @args ) = @_;
    my $args = $class->$orig(@_);

    my ( $loc_1, $loc_2, $letter, $pw ) = $args->{policy} =~ $POL_REGEX;
    $args->{_loc_1}    = $loc_1;
    $args->{_loc_2}    = $loc_2;
    $args->{_letter}   = $letter;
    $args->{_password} = $pw;

    return $args;
};

sub is_valid {
    my ($self) = @_;

    my $l = $self->_letter;
    my $p = $self->_password;
    my $l1m = substr($p, $self->_loc_1 - 1, 1) eq $l;
    my $l2m = substr($p, $self->_loc_2 - 1, 1) eq $l;

    return $l1m && !$l2m || $l2m && !$l1m;
}

use namespace::autoclean;
1;
