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
          bin/advent_2020_perl_day_1_part_2
          bin/advent_2020_perl_day_2_part_1
          bin/advent_2020_perl_day_2_part_2
          ]
    ],
);

package MY;
use File::ShareDir::Install qw(postamble);
