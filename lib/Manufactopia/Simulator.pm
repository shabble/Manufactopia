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
   handles   => {
                 tick_increment => 'inc',
                 tick_reset     => 'dec',
                }
  );

has 'config_file' =>
  (
   is  => 'ro',
   isa => 'Str',
   default => './config.yml',
  );

has 'machine_file' =>
  (
   is  => 'ro',
   isa => 'Str',
   default => './machine.yml',
  );

has 'config' =>
  (
   is   => 'ro',
   isa  => 'Manufactopia::ConfigParser',
   default => sub {
       Manufactopia::ConfigParser->new(filename => shift->config_file);
     },
   lazy => 1,
  );

has 'machine' =>
  (
   is   => 'ro',
   isa  => 'Manufactopia::InputParser',
   default => sub {
       Manufactopia::InputParser->new(filename => shift->machine_file);
     },
   lazy => 1,
  );

has 'grid' =>
  (
   is   => 'ro',
   isa  => 'Manufactopia::Grid',
   default => sub {
       my $self = shift;
       Manufactopia::Grid->new(width  => $self->config->get('width'),
                               height => $self->config->get('height'));
   },
   lazy => 1,
  );

has 'cursor' =>
  (
   is   => 'ro',
   isa  => 'Manufactopia::Cursor',
   default => sub { Manufactopia::Cursor->new; },
  );

has 'is_running' =>
  (
   is  => 'rw',
   isa => 'Bool',
   default => 1,
  );

sub step {
    my $self = shift;
    my $current_widget = $self->grid->widget_at_cursor($self->cursor);
    # TODO: action should be an obj?
    # what actions need to affect teh global gamestate?
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

sub start {
    my $self = shift;
    $self->is_running(1);
}

sub reset_machine {
    my ($self, $tape) = @_;

    $self->cursor->tape($tape);

    my $input_conf  = $self->config->get("input");
    $self->cursor->relocate($input_conf->{x}, $input_conf->{y});
    $self->tick_reset;
}

sub setup_grid {
    my ($self) = @_;


    my $w = $self->config->get('width');
    my $h = $self->config->get('height');

    my $input  = Manufactopia::Widget::Input->new;
    my $output = Manufactopia::Widget::Output->new;

    my $input_conf  = $self->config->get("input");
    my $output_conf = $self->config->get("output");

    $self->grid->add_widget($input,
                      $input_conf->{x},
                      $input_conf->{y},
                      $input_conf->{r});

    $self->grid->add_widget($output,
                      $output_conf->{x},
                      $output_conf->{y},
                      $output_conf->{r});
}

sub load_machine {
    my $self = shift;
    my $machine_spec = $self->machine;
    $machine_spec->populate_grid($self->grid, $self->config);
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
