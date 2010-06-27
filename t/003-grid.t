#!/usr/bin/env perl

use warnings;
use strict;

use lib './lib';

use FindBin qw/$RealBin/;

use Test::More; # tests => 10;
use Test::Exception;
use Data::Dumper;

BEGIN {
    use_ok 'Manufactopia::Grid';
    use_ok 'Manufactopia::Widget::Conveyor';
    use_ok 'Manufactopia::Widget::Input';

}

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
dies_ok { $grid->remove_widget_at_pos(10, 10) } 'removal outside grid bounds';
dies_ok { $grid->remove_widget_at_pos(0 , 0)  } 'removal of empty widget';

my $conv = Manufactopia::Widget::Conveyor->new;
ok ($grid->add_widget($conv, 0, 0, 90), 'adding widget to grid');

my $retrieved = $grid->widget_at_pos(0,0);
is ($conv, $retrieved, 'returned same object from grid');

is ($conv, $grid->remove_widget_at_pos(0,0), 'removed object returned');
isa_ok($grid->widget_at_pos(0,0), 'Manufactopia::Widget');

my $input_widget = Manufactopia::Widget::Input->new;
ok($grid->add_widget($input_widget, 0, 1, 0), 'added input widget');

dies_ok { $grid->add_widget($conv, 0, 1, 90) }
  "add_widget doesn't replace input widget";

done_testing;

