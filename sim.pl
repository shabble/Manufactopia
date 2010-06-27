#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Manufactopia::ConfigParser;
use Manufactopia::InputParser;

use Manufactopia::Grid;
use Manufactopia::Cursor;

use Manufactopia::Widget;
use Manufactopia::Widget::Conveyor;
use Manufactopia::Widget::Writer;
use Manufactopia::Widget::Branch;
use Manufactopia::Widget::Input;
use Manufactopia::Widget::Output;

my ($grid, $cursor, $config);
my $running = 1;
my $ticks = 0;

sub setup_grid {
    my ($w, $h) = @_;

    my $input  = Manufactopia::Widget::Input->new;
    my $output = Manufactopia::Widget::Output->new;

    my $input_conf  = $config->get("input");
    my $output_conf = $config->get("output");

    $grid->add_widget($input,
                      $input_conf->{x},
                      $input_conf->{y},
                      $input_conf->{r});

    $grid->add_widget($output,
                      $output_conf->{x},
                      $output_conf->{y},
                      $output_conf->{r});
}

sub load_machine {
    my $machine_spec = Manufactopia::InputParser->new(filename => 'machine.yml');
    $machine_spec->populate_grid($grid, $config);
}

sub step {
    my $current_widget = $grid->widget_at($cursor);
    # TODO: action should be an obj?
    my $action = $current_widget->evaluate($cursor);
    $action //= '';
    if ($action eq 'O') {
        print "Machine Completed!\n";
        $running = 0;
    } elsif ($action eq 'f') {
        print "Machine Dropped product!\n";
        $running = 0;
    }

    print $current_widget->name, "\n";
    $ticks++;
}

sub reset_machine {
    my ($tape) = @_;

    $cursor->tape($tape);

    my $input_conf  = $config->get("input");
    $cursor->relocate($input_conf->{x}, $input_conf->{y});
    $ticks = 0;
}
sub main {

    my $config_file = $ARGV[0] // 'config.yml';
    $config = Manufactopia::ConfigParser->new(filename => $config_file);

    my $w = $config->get('width');
    my $h = $config->get('height');


    $grid   = Manufactopia::Grid->new(width => $w, height => $h);
    $cursor = Manufactopia::Cursor->new;

    setup_grid($w, $h);
    load_machine;

    my @testcases = @{$config->get('testcases')};
    my $test_num = 0;

    foreach my $test (@testcases) {
        my $start_tape = [split '', $test->{start_tape}];
        $running = 1;
        reset_machine($start_tape);
        print "Test: $test_num\n";

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
        }

        $test_num++;
    }
}

main;
