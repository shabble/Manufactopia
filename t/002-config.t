#!/usr/bin/env perl

use warnings;
use strict;

use lib './lib';

use FindBin qw/$RealBin/;

use Test::More; # tests => 10;
use Test::Exception;
use Data::Dumper;

BEGIN { use_ok 'Manufactopia::ConfigParser'; }


my $config_parser;

dies_ok { $config_parser = Manufactopia::ConfigParser->new; }
  'fails on nonexistent config';

my $conf_file = $RealBin . "/configs/002-generic-config.yml";

ok(-f $conf_file, "Config file $conf_file exists");

lives_ok { $config_parser
             = Manufactopia::ConfigParser->new(filename =>
                                               $conf_file); }
  'creating a config object';

isa_ok ($config_parser, 'Manufactopia::ConfigParser');


# general config
my $w = $config_parser->get('width');
my $h = $config_parser->get('height');

is( $w, 3, 'fetching width');
is( $h, 5, 'fetching height');

ok( $config_parser->get('problem_statement') eq 'problem statement' );

my $input = $config_parser->get('input');
is (ref $input, 'HASH', 'input config is hashref');
ok (exists $input->{x}, 'input has x coordinate');
ok (exists $input->{y}, 'input has y coordinate');
ok (exists $input->{r}, 'input has rotation');

ok ($input->{x} >= 0 && $input->{x} < $w, 'input x within width');
ok ($input->{y} >= 0 && $input->{y} < $h, 'input y within height');
ok ($input->{r} % 90 == 0, 'input rot is 90 degree angle');

my $output = $config_parser->get('output');
is (ref $output, 'HASH', 'output config is hashref');

ok (exists $output->{x}, 'output has x coordinate');
ok (exists $output->{y}, 'output has y coordinate');
ok (exists $output->{r}, 'output has rotation');

ok ($output->{x} >= 0 && $output->{x} < $w, 'output x within width');
ok ($output->{y} >= 0 && $output->{y} < $h, 'output y within height');
ok ($output->{r} % 90 == 0, 'output rot is 90 degree angle');

# permitted widgets
my $permitted_widgets = $config_parser->get('permitted_widgets');
ok( ref($permitted_widgets) eq 'ARRAY', 'permitted widgets is arrayref' );

my @permitted = @$permitted_widgets;
foreach my $p (@permitted) {
    is (ref $p,  'HASH', 'permitted entry is hashref');
    is (scalar keys %$p, 1, 'single key per entry');
    my $type = [keys %$p]->[0];
    my $entry = $p->{$type};
    is (ref $entry, 'HASH', 'entry is hashref');

    # mandatory
    ok (exists $entry->{cost}, 'has cost entry');

    if ($type eq 'writer' or $type eq 'branch') {
        ok (exists $entry->{colour}, 'branch and writer has colour entry');
    }
}

# test cases
my $testcases = $config_parser->get('testcases');
is (ref $testcases, 'ARRAY', 'testcases is array');

foreach my $test (@$testcases) {
    is (ref $test, 'HASH', 'test is hashref');
    ok (exists $test->{start_tape}, 'test has a starting tape');
    ok (exists $test->{value}, 'test has a value');

    my $end_tape_exists = exists $test->{end_tape};
    my $accept_exists   = exists $test->{accept};

    ok ($end_tape_exists ^ $accept_exists, 'only one of end_tape and accept exists');

    if ($end_tape_exists) {
        ok(tape_parseable($test->{end_tape}), 'end_tape spec is parseable');
    }
}

sub tape_parseable {
    my $tape = shift;
    my @tokens = split ' ', $tape;
    return @tokens;
}


done_testing;

