#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => "Advent",
    VERSION_FROM => "lib/Advent.pm",
    EXE_FILES    => ['bin/day_2_part_2'],
);
