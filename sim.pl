#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Manufactopia::Simulator;

my $sim;

sub draw {
    print $sim->grid->draw($sim->cursor);
    print "Tape:\n";
    print $sim->cursor->draw;
    print "\n";
}

sub main {
    my @args;
    push @args, config_file  => $ARGV[0] if $ARGV[0];
    push @args, machine_file => $ARGV[1] if $ARGV[1];
    push @args, display_callback => \&draw;

    $sim = Manufactopia::Simulator->new(@args);


    my $problem_statement = $sim->problem_str;
    $problem_statement .= "\n" . ("-" x length $problem_statement) . "\n\n";
    print $problem_statement;

    my $machine_cost = $sim->machine->cost;
    print "Machine Cost: $machine_cost\n";

    # TODO: account for bounding-box floorplan costs.

    $sim->run;
}

main;
