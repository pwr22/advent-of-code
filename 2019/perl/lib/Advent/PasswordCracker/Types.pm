package Advent::PasswordCracker::Types;

use strict;
use warnings;
use Carp;
use Const::Fast;
use Type::Library -base;
use Type::Utils -all;
use Types::Standard ':all';
use Types::Common::Numeric ':all';

const my $PW_LEN => 6;

const my $digits => declare as StrMatch [qr/[0-9]+/];

const my $right_length => declare as $digits, where { length($_) == $PW_LEN };

const my $increasing_digits => declare as $digits,
  where {
    croak "length of '$_' must be at least 2"
      unless length($_) >= 2;

    for my $idx ( 1 .. length($_) - 1 ) {
        return 0
          unless substr( $_, $idx, 1 ) >= substr( $_, $idx - 1, 1 );
    }

    return 1;
  };

const my $double_digits => declare as $digits,
  where {
    croak "length of '$_' must be at least 2"
      unless length($_) >= 2;

    for my $idx ( 1 .. length($_) - 1 ) {
        # do we have double digits?
        return 1
          if substr( $_, $idx, 1 ) == substr( $_, $idx - 1, 1 );
    }

    return 0;
  };

const my $only_double_digits => declare as $digits,
  where {
    croak "length of '$_' must be at least 2"
      unless length($_) >= 2;

    for my $idx ( 1 .. length($_) - 1 ) {
        my $digit = substr( $_, $idx, 1 );

        # do we have double digits?
        next unless substr( $_, $idx - 1, 1 ) == $digit;

        # check we don't have more than double digits
        next if $idx >= 2              && substr( $_, $idx - 2, 1 ) == $digit;
        next if $idx <= length($_) - 2 && substr( $_, $idx + 1, 1 ) == $digit;

        return 1;
    }

    return 0;
  };

my $password = intersection 'Password', [ $right_length, $increasing_digits, $double_digits ];
intersection 'RevisedPassword', [ $right_length, $increasing_digits, $only_double_digits ];

1;
