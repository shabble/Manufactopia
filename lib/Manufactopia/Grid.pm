package Manufactopia::Grid;

use Moose;
use Data::Dumper;

has 'width'
  => (
      is => 'rw',
      isa => 'Int',
     );

has 'height'
  => (
      is => 'rw',
      isa => 'Int',
     );

has 'grid'
  => (
      is  => 'rw',
      isa => 'ArrayRef[ArrayRef[Manufactopia::Widget]]',
     );

sub BUILD {
    my $self = shift;
    my @grid;
    my $row;
    foreach my $y (0..$self->height -1) {
        $row = [];
        foreach my $x (0..$self->width -1) {
            push @$row, new Manufactopia::Widget();
        }
        push @grid, $row;
    }

    $self->grid(\@grid);
}

sub widget_at {
    my ($self, $cursor) = @_;
    my $tile = $self->grid->[$cursor->ypos]->[$cursor->xpos];
    return $tile;
}

sub add_widget {
    my ($self, $widget, $x, $y, $rot) = @_;
    my $grid = $self->grid;
    if (defined $rot) {
        $widget->rotation($rot);
    }
    $grid->[$y]->[$x] = $widget;
}

sub draw {
    my ($self, $cursor) = @_;
    my $grid = $self->grid;
    my $print_grid = '';

    my $bold = `tput bold`;
    my $unbold = `tput rmso`;

    my ($x, $y) = (0, 0);
    foreach my $row (@$grid) {
        foreach my $widget (@$row) {
            my $glyph = $widget->glyph;
            if ($x == $cursor->xpos && $y == $cursor->ypos) {
                $print_grid .= $bold . $glyph . $unbold;
            } else {
                $print_grid .= $glyph;
            }
            $x++;
        }
        $y++; $x = 0;
        $print_grid .= "\n";
    }
    return $print_grid, "\n";
}
no Moose;
__PACKAGE__->meta->make_immutable;

