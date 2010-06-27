#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Manufactopia::ConfigParser;
use Manufactopia::InputParser;

use Manufactopia::Grid;
use Manufactopia::Cursor;

use Manufactopia::Simulator;

use Manufactopia::Widget;
use Manufactopia::Widget::Conveyor;
use Manufactopia::Widget::Writer;
use Manufactopia::Widget::Branch;
use Manufactopia::Widget::Input;
use Manufactopia::Widget::Output;

#TODO: move a whole bunch of this into Simulator.pm
my $sim;



sub draw {
    print $sim->grid->draw($sim->cursor);
    print "Tape:\n";
    print $sim->cursor->draw;
    print "\n";
}

sub main {

    # my $config_file = $ARGV[0] // 'config.yml';
    # $config = Manufactopia::ConfigParser->new(filename => $config_file);
    $sim = Manufactopia::Simulator->new;
    $sim->setup_grid;
    $sim->load_machine;

    my @testcases = @{$sim->config->get('testcases')};
    my $test_num = 0;

    foreach my $test (@testcases) {
        my $start_tape = [split '', $test->{start_tape}];

        $sim->reset_machine($start_tape);
        $sim->start;

        print "Test: $test_num\n";

        draw();

        while ($sim->is_running) {
            <STDIN>;
            $sim->step();
            draw();
        }

        $test_num++;
    }
}

main;
