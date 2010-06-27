#!/usr/bin/env perl

use Test::Harness;

my @files;
if (@ARGV) {
    @files = @ARGV;
} else {
    @files= glob "t/*.t";
}

runtests @files;

