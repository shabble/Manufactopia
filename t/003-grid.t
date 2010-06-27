#!/usr/bin/env perl

use warnings;
use strict;

use lib './lib';

use FindBin qw/$RealBin/;

use Test::More; # tests => 10;
use Test::Exception;
use Data::Dumper;

BEGIN { use_ok 'Manufactopia::Grid'; }

my $grid;
dies_ok { $grid = Manufactopia::Grid->new; } 'needs w and h args';

my $w = 3;
my $h = 3;

$grid = Manufactopia::Grid->new(width => $w, height => $h);
isa_ok($grid, 'Manufactopia::Grid');
is ($grid->width,  $w, 'width set correctly');
is ($grid->height, $h, 'height set correctly');

my $grid_rows = $grid->grid;
is (ref $grid_rows, 'ARRAY');
is (scalar @$grid_rows, $h);

my $column = $grid_rows->[0];
is (ref $column, 'ARRAY');
is (scalar @$column, $w);

my $widget = $column->[0];
isa_ok ($widget, 'Manufactopia::Widget');

#TODO: test add_widget, and that it correctly replaces over same tile.

done_testing;

