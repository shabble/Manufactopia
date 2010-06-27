#!/usr/bin/env perl

use Test::Harness;

my @files = glob "t/*.t";
runtests @files;

