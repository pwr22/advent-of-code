#!/usr/bin/perl

use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share 'inputs';

WriteMakefile(
    NAME         => "Advent",
    VERSION_FROM => "lib/Advent.pm",
    EXE_FILES    => [
        qw[
          bin/day_2_part_2 bin/day_3_part_1 bin/day_3_part_2 bin/day_4_part_1
          bin/day_4_part_2 bin/day_5_part_1 bin/day_5_part_2 bin/day_6_part_1
          bin/day_6_part_2 bin/day_7_part_1 bin/day_7_part_2 bin/get-input bin/intcode
          ]
    ],
);

package MY;
use File::ShareDir::Install qw(postamble);
