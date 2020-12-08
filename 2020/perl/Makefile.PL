#!/usr/bin/env perl

use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share 'inputs';

WriteMakefile(
    NAME         => "Advent-2020",
    VERSION_FROM => "lib/Advent/2020.pm",
    EXE_FILES    => [
        qw[
            bin/advent_2020_perl_day_1_part_1
          ]
    ],
);

package MY;
use File::ShareDir::Install qw(postamble);
