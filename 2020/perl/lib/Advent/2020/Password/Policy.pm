package Advent::2020::Password::Policy;

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

has [qw[ _min_count _max_count ]] => (
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

    my ( $min, $max, $letter, $pw ) = $args->{policy} =~ $POL_REGEX;
    $args->{_min_count} = $min;
    $args->{_max_count} = $max;
    $args->{_letter}    = $letter;
    $args->{_password}  = $pw;

    return $args;
};

sub is_valid {
    my ($self) = @_;

    my $l  = $self->_letter;
    my $lc = () = $self->_password =~ /\Q$l/g;

    return $lc >= $self->_min_count && $lc <= $self->_max_count;
}

use namespace::autoclean;
1;
