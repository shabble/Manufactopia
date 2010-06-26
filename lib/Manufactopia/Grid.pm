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

#    print Dumper(\@grid);

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
    my $self = shift;
    my $grid = $self->grid;
    my $print_grid = '';

    foreach my $row (@$grid) {
        foreach my $widget (@$row) {

            my $glyph = $widget->glyph;
            $print_grid .= $glyph;

        }
        $print_grid .= "\n";
    }
    return $print_grid, "\n";
}
no Moose;
__PACKAGE__->meta->make_immutable;

