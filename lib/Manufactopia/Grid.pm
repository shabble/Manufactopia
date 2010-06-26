package Manufactopia::Grid;

use Moose;
use Data::Dumper;
use Manufactopia::Tile;

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
      isa => 'ArrayRef[ArrayRef[Manufactopia::Tile]]',
     );

sub BUILD {
    my $self = shift;
    my @grid;
    my $row;
    foreach my $y (0..$self->height -1) {
        $row = [];
        foreach my $x (0..$self->width -1) {
            push @$row, new Manufactopia::Tile();
        }
        push @grid, $row;
    }

    print Dumper(\@grid);

    $self->grid(\@grid);
}

sub add_widget {
    my ($self, $widget, $x, $y, $rot) = @_;
    my $grid = $self->grid;
    $rot //= 0;
    my $tile = $grid->[$y]->[$x];
    $tile->contents($widget);
    $tile->rotation($rot);
}

sub draw {
    my $self = shift;
    my $grid = $self->grid;
    my $print_grid = '';

    foreach my $row (@$grid) {
        foreach my $tile (@$row) {
#            my $widget = $tile->contents;
            my $glyph = $tile->glyph;

            # if (defined $widget) {
            #     $glyph = $widget->glyph;
            # } else {
            #     $glyph = '#';
            # }

            $print_grid .= $glyph;

        }
        $print_grid .= "\n";
    }
    print $print_grid, "\n";
}
no Moose;
__PACKAGE__->meta->make_immutable;

