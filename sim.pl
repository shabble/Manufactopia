#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';
use Manufactopia::Grid;
use Manufactopia::Widget;
use Manufactopia::Widget::Conveyor;
use Manufactopia::Widget::Input;


sub main {
    my ($w, $h) = qw/3 3/;

    my $grid  = Manufactopia::Grid->new(width => $w, height => $h);
    my $input = Manufactopia::Widget::Input->new;
    $grid->add_widget($input, 1, 0);

    my $conv = Manufactopia::Widget::Conveyor->new();
    $grid->add_widget($conv, 1, 1, 180);
    $grid->draw;
}




main;
