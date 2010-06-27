#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Manufactopia::ConfigParser;
use Manufactopia::InputParser;

use Manufactopia::Grid;
use Manufactopia::Cursor;

use Manufactopia::Simulator;

# use Manufactopia::Widget;
# use Manufactopia::Widget::Conveyor;
# use Manufactopia::Widget::Writer;
# use Manufactopia::Widget::Branch;
# use Manufactopia::Widget::Input;
# use Manufactopia::Widget::Output;

my $sim;

sub draw {
    print $sim->grid->draw($sim->cursor);
    print "Tape:\n";
    print $sim->cursor->draw;
    print "\n";
}

sub main {

    $sim = Manufactopia::Simulator->new;
    $sim->setup_grid;
    $sim->load_machine;

    my $problem_statement = $sim->config->get('problem_statement');
    $problem_statement .= "\n" . ("-" x length $problem_statement) . "\n\n";
    print $problem_statement;

    my $machine_cost = $sim->machine->cost;
    print "Machine Cost: $machine_cost\n";
    # TODO: account for bounding-box floorplan costs.

    my @testcases = @{$sim->config->get('testcases')};
    my $test_num = 0;

    foreach my $test (@testcases) {
        my $start_tape = [split ' ', $test->{start_tape}];

        $sim->reset_machine($start_tape);
        $sim->start;

        print "Test: $test_num\n";

        draw();

        while ($sim->is_running) {
            <STDIN>;
            $sim->step();
            draw();
        }

        my $result = $sim->evaluate_end_condition($test);
        if ($result) {
            print "***Test passed!\n"
        } else {
            print "***Test failed!\n"
        }

        $test_num++;
    }
}

main;
