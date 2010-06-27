package Manufactopia::Grid;

use Moose;
use Data::Dumper;
use Manufactopia::Widget;

has 'width'
  => (
      is       => 'ro',
      isa      => 'Int',
      required => 1,
     );

has 'height'
  => (
      is       => 'ro',
      isa      => 'Int',
      required => 1,
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
            push @$row, Manufactopia::Widget->new();
        }
        push @grid, $row;
    }

    $self->grid(\@grid);
}

sub widget_at_pos {
    my ($self, $x, $y) = @_;
    my $tile = $self->grid->[$y]->[$x];
    return $tile;
}

sub widget_at_cursor {
    my ($self, $cursor) = @_;
    return $self->widget_at_pos($cursor->xpos, $cursor->ypos);
}
# TODO: need some way of having two conveyors on a single square
# as long as they're orthogonal.
sub add_widget {
    my ($self, $widget, $x, $y, $rot) = @_;
    my $grid = $self->grid;
    if (defined $rot) {
        $widget->rotation($rot);
    }
    # TODO: error checking (can't place outside grid, or in IO)
    unless ($self->_check_bounds($x, $y)) {
        die "Can't place a widget outside the grid bounds";
    }

    unless ($self->_check_placement($x, $y)) {
        die "Can't place a widget on an input or output element";
    }

    $grid->[$y]->[$x] = $widget;
}

sub remove_widget_at_pos {
    my ($self, $x, $y) = @_;

    unless ($self->_check_bounds($x, $y)) {
        die "Can't remove a widget outside the grid bounds";
    }

    my $existing = $self->widget_at_pos($x, $y);

    unless (ref($existing) ne 'Manufactopia::Widget') {
        die "Can't remove a widget from an already empty tile";
    }
    my $grid = $self->grid;
    $grid->[$y]->[$x] = Manufactopia::Widget->new();
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

sub _check_placement {
    my ($self, $x, $y) = @_;
    my $existing = $self->widget_at_pos($x, $y);

    if (ref($existing) eq 'Manufactopia::Widget::Input' ||
        ref($existing) eq 'Manufactopia::Widget::Output') {

        return 0;
    } else {
        return 1;
    }
}
sub _check_bounds {
    my ($self, $x, $y) = @_;
    if ($x >= 0 && $x < $self->width) {
        if ($y >= 0 && $y < $self->height) {
            return 1;
        }
    }
    return 0;
}
no Moose;
__PACKAGE__->meta->make_immutable;

