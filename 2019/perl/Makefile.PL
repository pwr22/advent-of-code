#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => "Advent",
    VERSION_FROM => "lib/Advent.pm",
    EXE_FILES    => [
        'bin/day_2_part_2', 'bin/day_3_part_1', 'bin/day_3_part_2', 'bin/day_4_part_1',
        'bin/day_4_part_2', 'bin/day_5_part_1', 'bin/day_5_part_2'
    ],
);
