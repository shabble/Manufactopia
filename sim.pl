#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';
use Manufactopia::Grid;
use Manufactopia::Cursor;

use Manufactopia::Widget;
use Manufactopia::Widget::Conveyor;
use Manufactopia::Widget::Input;
use Manufactopia::Widget::Output;

my ($grid, $cursor);

sub setup_grid {

    my $input  = Manufactopia::Widget::Input->new;
    my $output = Manufactopia::Widget::Output->new;

    $grid->add_widget($input,  1, 0);
    $grid->add_widget($output, 1, 2);
    $cursor->tape([qw/R R R B B R/]);
    $cursor->move(1, 0);
}

sub load_machine {

    my $conv = Manufactopia::Widget::Conveyor->new();
    $grid->add_widget($conv, 1, 1, 180);
}

sub step {
    my $current_widget = $grid->widget_at($cursor);
    my $action = $current_widget->evaluate($cursor);
    #$action->apply;
    $action //= '';
    if ($action eq 'O') {
        print "Machine Completed!\n";
        exit(0);
    }

    print $current_widget;
}

sub main {
    my ($w, $h) = qw/3 3/;

    $grid   = Manufactopia::Grid->new(width => $w, height => $h);
    $cursor = Manufactopia::Cursor->new;

    setup_grid;
    load_machine;
#    init_cursor($grid);
#    $grid->draw;
}

main;

while (1) {
    print $grid->draw;
    print "Tape:\n";
    print $cursor->draw;
    print "\n";
    <STDIN>;
    step();
    print "\n";

}
