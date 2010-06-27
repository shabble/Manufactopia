package Manufactopia::Cursor;

use Carp;
use Moose;

our $rotation_map =
  {
   0   => [[1,  0],
           [0,  1]],

   90  => [[0, -1],
           [1,  0]],

   180 => [[-1, 0],
           [0, -1]],

   270 => [[0,  1],
           [-1, 0]],
  };

has 'prevx' =>
  (
   is  => 'rw',
   isa => 'Int',
  );

has 'prevy' =>
  (
   is  => 'rw',
   isa => 'Int',
  );

has 'xpos' =>
  (
   is  => 'rw',
   isa => 'Int',
  );

has 'ypos' =>
  (
   is  => 'rw',
   isa => 'Int',
  );

has 'tape' =>
  (
   is  => 'rw',
   isa => 'ArrayRef[Str]',
   traits  => ['Array'],
   default => sub { [ ] },
   handles =>
   {
    tape_write => 'push',
    tape_read  => 'shift',
   },
  );

sub tape_peek {
    my $self = shift;
    return $self->tape->[0];
}


sub tape_compare {
    my ($self, $other_tape) = @_;
    my $tape = $self->tape;
    my $index = 0;
    foreach my $token (@$tape) {
        if ($token ne $other_tape->[$index]) {
            return 0;
        }
        $index++;
    }
    return 1;
}

# ------------ Movement methods ------------------------------------------

sub relocate {
    my ($self, $x, $y) = @_;
    $self->xpos($x);
    $self->ypos($y);
}

sub move {
    my ($self, $x_offset, $y_offset, $rotation) = @_;
    $rotation //= 0;
    my $mapping = $rotation_map->{$rotation};

    my $map_x = $mapping->[0];
    my $new_x = ($x_offset * $map_x->[0]) + ($y_offset * $map_x->[1]);

    my $map_y = $mapping->[1];
    my $new_y = ($x_offset * $map_y->[0]) + ($y_offset * $map_y->[1]);

#    print "Move: $x_offset, $y_offset, $rotation\n";
#    print "New pos: $new_x, $new_y\n";

    $self->prevx($self->xpos);
    $self->prevy($self->ypos);

    $self->relocate($self->xpos + $new_x, $self->ypos + $new_y);
}

sub move_forward {
    my ($self, $rotation) = @_;
    $self->move(0, 1, $rotation);
}

sub move_backward {
    my ($self, $rotation) = @_;
    $self->move(0, -1, $rotation);

}

sub move_left {
    my ($self, $rotation) = @_;
    $self->move(-1, 0, $rotation);

}

sub move_right {
    my ($self, $rotation) = @_;
    $self->move(1, 0, $rotation);

}

sub draw {
    my $self = shift;
    return '[' . $self->xpos . ', ' . $self->ypos . '] '
      . '[' . join(', ', @{$self->tape}) . ']';
}

no Moose;
__PACKAGE__->meta->make_immutable;
