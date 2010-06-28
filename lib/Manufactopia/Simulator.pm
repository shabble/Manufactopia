package Manufactopia::Simulator;

use strict;
use warnings;

use Carp;
use Moose;

use Manufactopia::ConfigParser;
use Manufactopia::InputParser;

use Manufactopia::Grid;
use Manufactopia::Cursor;

has 'ticks' =>
  (
   traits    => ['Counter'],
   is        => 'ro',
   isa       => 'Num',
   default   => 0,
   handles   =>
   {
    tick_increment => 'inc',
    tick_reset     => 'dec',
   },
  );

has 'display_callback' =>
  (
   is  => 'rw',
   isa => 'CodeRef',
   required => 1,
  );

has 'config_file' =>
  (
   is  => 'rw',
   isa => 'Str',
   default => './config.yml',
   trigger => \&_load_config_file,
  );

has 'machine_file' =>
  (
   is  => 'rw',
   isa => 'Str',
   default => './machine.yml',
   trigger => \&_load_machine_file,
  );

has 'config' =>
  (
   is      => 'rw',
   isa     => 'Manufactopia::ConfigParser',
   builder => '_build_config',
  );

has 'machine' =>
  (
   is      => 'rw',
   isa     => 'Manufactopia::InputParser',
   builder => '_load_machine_file',
   lazy    => 1,
  );

has 'grid' =>
  (
   is      => 'ro',
   isa     => 'Manufactopia::Grid',
   builder => '_build_grid',
   lazy    => 1,
  );

has 'cursor' =>
  (
   is      => 'ro',
   isa     => 'Manufactopia::Cursor',
   default => sub { Manufactopia::Cursor->new; },
  );

has 'is_running' =>
  (
   is      => 'rw',
   isa     => 'Bool',
   default => 1,
  );

sub _load_machine_file {
    my $self = shift;
    return Manufactopia::InputParser->new(filename
                                          => $self->machine_file);
}
sub _load_config_file {
    my $self = shift;
    return Manufactopia::ConfigParser->new(filename
                                           => $self->config_file);
}

sub _build_grid {
    my $self = shift;
    my $grid = Manufactopia::Grid->new(width  => $self->config->get('width'),
                                       height => $self->config->get('height'));
    return $grid;
}


sub _build_config {
    my $self = shift;
    my $cfg = $self->_load_config_file;
    $self->config($cfg);

    my $input  = Manufactopia::Widget::Input->new;
    my $output = Manufactopia::Widget::Output->new;

    my $input_conf  = $cfg->get("input");
    my $output_conf = $cfg->get("output");

    $self->grid->add_widget($input,
                      $input_conf->{x},
                      $input_conf->{y},
                      $input_conf->{r});

    $self->grid->add_widget($output,
                      $output_conf->{x},
                      $output_conf->{y},
                      $output_conf->{r});

    return $cfg;
}

sub problem_str {
    my $self = shift;
    return $self->config->get('problem_statement');
}

sub step {
    my $self = shift;
    my $current_widget = $self->grid->widget_at_cursor($self->cursor);
    # TODO: action should be an obj?
    # what actions need to affect the global gamestate?
    # - Termination
    my $action = $current_widget->evaluate($self->cursor);
    # TODO: figure out where and how to add the overall evaluation function
    $action //= '';
    if ($action eq 'O') {
        print "product reached output!\n";
        $self->is_running(0);
    } elsif ($action eq 'f') {
        print "Machine Dropped product!\n";
        $self->is_running(0);
    }

    print $current_widget->name, "\n";
    $self->tick_increment;
}

sub run {
    my $self = shift;
    $self->machine->populate_grid($self->grid, $self->config);

    my @testcases = @{$self->config->get('testcases')};
    my $test_num = 0;

    foreach my $test (@testcases) {
        my $start_tape = [split ' ', $test->{start_tape}];
        print "Test: $test_num\n";
        $self->reset_sim($start_tape);
        $self->is_running(1);

        while ($self->is_running) {

            $self->display_callback->();
            <STDIN>;
            $self->step();
        }

        my $result = $self->evaluate_end_condition($test);

        if ($result) {
            print "***Test passed!\n"
        } else {
            print "***Test failed!\n"
        }

        $test_num++;
    }
}

sub reset_sim {
    my ($self, $tape) = @_;

    $self->cursor->tape($tape);

    my $input_conf = $self->config->get("input");
    $self->cursor->relocate($input_conf->{x}, $input_conf->{y});
    $self->tick_reset;
}

sub load_machine {
    my ($self, $filename) = @_;
    if (defined $filename) {
        $self->machine_file($filename);
    }
    #TODO: do we need to reset the grid here?
#    $self->grid->reset;
}

sub evaluate_end_condition {
    my ($self, $testcase) = @_;
    my $should_accept = $testcase->{accept} // 1;
    my $end_widget = $self->grid->widget_at_cursor($self->cursor);

    my $output_tape = exists($testcase->{end_tape})
      ?[ split(' ', $testcase->{end_tape}) ]
        :undef;

    my $has_output_tape = defined($output_tape);

    if ($end_widget->is_output_widget) {
        if ($has_output_tape) {
            if ($self->cursor->tape_compare($output_tape)) {
                return 1;
            } else {
                return 0;
            }
        }
        if ($should_accept) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if ($should_accept) {
            return 0;
        } else {
            return 1;
        }
    }
}
no Moose;
__PACKAGE__->meta->make_immutable;
