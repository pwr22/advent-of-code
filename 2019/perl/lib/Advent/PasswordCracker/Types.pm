package Advent::PasswordCracker::Types;

use strict;
use warnings;
use Const::Fast;
use Type::Library -base;
use Type::Utils -all;
use Types::Standard ':all';
use Types::Common::Numeric ':all';

const my $PW_LEN => 6;

const my $digits => declare as StrMatch [qr/[0-9]+/];

const my $right_length => declare as $digits, where { length($_) == $PW_LEN };

const my $increasing_digits => declare as $digits, where {
    for my $idx ( 1 .. length($_) - 1 ) {
        return 0
          unless substr( $_, $idx, 1 ) >= substr( $_, $idx - 1, 1 );
    }

    return 1;
};

const my $double_digits => declare as $digits, where {
    for my $idx ( 1 .. length($_) - 1 ) {
        return 1
          if substr( $_, $idx, 1 ) == substr( $_, $idx - 1, 1 );
    }

    return 0;
};

intersection 'Password', [ $right_length, $increasing_digits, $double_digits ];

1;
