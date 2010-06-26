#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';
use Manufactopia::Grid;
use Manufactopia::Widget;
use Manufactopia::Widget::Conveyor;

sub main {
    my $grid = Manufactopia::Grid->new(width => 2, height => 2);
    my $conv = Manufactopia::Widget::Conveyor->new();

    $grid->add_widget($conv, 0, 0);
    $grid->draw;
}




main;
