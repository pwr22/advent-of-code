package Advent::SignalAmplifier;

use strict;
use warnings;
use Moo;
use MooX::StrictConstructor;
use Types::Standard ':all';
use Algorithm::Permute qw( permute );

use Advent::Intcode;

has intcode => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

sub find_optimal_phases {
    my ( $self ) = shift;

    my @phases  = (0 .. 4);
    my $max_sig = 0;

    permute {
        my $output = "0\n";
        for (@phases) {
            my $input = "$_\n$output";
            open my $ifh, '<', \$input;
            open my $ofh, '>', \$output;
            my $sim = Advent::Intcode->new( state => $self->intcode, input => $ifh, output => $ofh );
            $sim->run();
        }

        chomp $output;
        $max_sig = $output if $output > $max_sig;
    }
    @phases;

    return $max_sig;
}

1;
