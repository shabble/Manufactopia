package Manufactopia::InputParser;

use strict;
use warnings;

use Moose;
use YAML::Any;
use Data::Dumper;

use Manufactopia::Grid;

use Manufactopia::Widget;
use Manufactopia::Widget::Conveyor;
use Manufactopia::Widget::Writer;
use Manufactopia::Widget::Branch;
use Manufactopia::Widget::Input;
use Manufactopia::Widget::Output;



has 'filename' =>
  (
   is  => 'ro',
   isa => 'Str',
   required => 1,
  );

has 'machine' =>
  (
   traits  => ['Array'],
   is      => 'rw',
   isa     => 'ArrayRef[Any]',
   default => sub { [] },
  );

has 'cost' =>
  (
   is  => 'rw',
   isa => 'Int',
   default => 0,
  );

sub BUILD {
    my $self = shift;
    my $data = YAML::Any::LoadFile($self->filename);
    $self->machine($data);
}

#TODO: refactor this into Config class.
#TODO: is there a nicer data structure for this? Probably doesn't matter
# since we're not going to have a huge list of components (I hope)
sub _is_permitted_widget {
    my ($widget_type, $widget_colour, $permitted) = @_;

    foreach my $allowed (@$permitted) {
        my $type = [ keys %$allowed ]->[0];

        if ($widget_type eq $type) {
            my $colour = $allowed->{$type}->{colour} // '';
            if ($widget_colour eq $colour) {
                return 1;
            }
        }
    }
    return 0;
}

sub populate_grid {
    my ($self, $grid, $config) = @_;

    my $permitted = $config->get('permitted_widgets');
    my $total_cost = 0;

    foreach my $entry (@{$self->machine}) {
        my $widget;
        my $type = [ keys %$entry ]->[0];
        my $params = $entry->{$type};

        my $colour = $params->{colour} // '';

        if ($type eq 'conveyor') {
            $widget = Manufactopia::Widget::Conveyor->new;

        } elsif ($type eq 'writer') {
            $widget = Manufactopia::Widget::Writer->new(colour => $colour);

        } elsif ($type eq 'branch') {
#            print "Colour: $params->{flipped}\n";
            if (exists($params->{flipped}) && $params->{flipped}) {
                $colour = scalar reverse $colour;
            }

            $widget = Manufactopia::Widget::Branch->new(colour => $colour);

        } else {
            die "Invalid part in " . $self->filename . ": $type";
        }

        #TODO: error checking here.
        if (_is_permitted_widget($type, $colour, $permitted)) {
            $grid->add_widget(
                              $widget,
                              $params->{x},
                              $params->{y},
                              $params->{r}
                             );
        } else {
            #TODO: nicer aerror handling
            my $col_msg = length($colour)?"with colour '$colour' ":"";
            my $msg = "Widget type '$type' " . $col_msg
              . "is not permitted by problem rules";
            die $msg;
        }
    }
}
no Moose;
__PACKAGE__->meta->make_immutable;

