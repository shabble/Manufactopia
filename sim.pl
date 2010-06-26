#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';
use Manufactopia::Grid;
use Manufactopia::Cursor;

use Manufactopia::Widget;
use Manufactopia::Widget::Conveyor;
use Manufactopia::Widget::Writer;
use Manufactopia::Widget::Branch;
use Manufactopia::Widget::Input;
use Manufactopia::Widget::Output;

my ($grid, $cursor);
my $running = 1;
sub setup_grid {
    my ($w, $h) = @_;
    my $input  = Manufactopia::Widget::Input->new;
    my $output = Manufactopia::Widget::Output->new;

    $grid->add_widget($input,  int($w/2), 0);
    $grid->add_widget($output, int($w/2), $h-1);
    $cursor->tape([qw/R R R B B R/]);
    $cursor->relocate(1, 0);
}

sub load_machine {

    my $conv = Manufactopia::Widget::Conveyor->new();
    $grid->add_widget($conv, 1, 1, 0);
    my $conv2 = Manufactopia::Widget::Conveyor->new();
    $grid->add_widget($conv2, 1, 2, 90);
    my $writer1 = Manufactopia::Widget::Writer->new(colour => 'R');
    $grid->add_widget($writer1, 0, 2, 0);
    my $conv3 = Manufactopia::Widget::Conveyor->new();
    $grid->add_widget($conv3, 0, 3, 270);

    my $branch = Manufactopia::Widget::Branch->new(colour => 'RB');
    $grid->add_widget($branch, 1, 3, 0);

}

sub step {
    my $current_widget = $grid->widget_at($cursor);
    my $action = $current_widget->evaluate($cursor);
    #$action->apply;
    $action //= '';
    if ($action eq 'O') {
        print "Machine Completed!\n";
        $running = 0;
    } elsif ($action eq 'f') {
        print "Machine Dropped product!\n";
        $running = 0;
    }

    print $current_widget->name, "\n";
}

sub main {
    my ($w, $h) = qw/3 5/;

    $grid   = Manufactopia::Grid->new(width => $w, height => $h);
    $cursor = Manufactopia::Cursor->new;

    setup_grid($w, $h);
    load_machine;
#    init_cursor($grid);
#    $grid->draw;
}

main;
print $grid->draw($cursor);
print "Tape:\n";
print $cursor->draw;
print "\n";

while ($running) {
    <STDIN>;
    step();
    print $grid->draw($cursor);
    print "Tape:\n";
    print $cursor->draw;
    print "\n";
    print "\n";

}
