package Manufactopia::Widget::Writer;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';
has '+name' => ( default => 'Tape Writer' );

has 'colour' =>
  (
   is  => 'rw',
   isa => 'Str',

  );

sub evaluate {
    my ($self, $cursor) = @_;
    print "Writing to tape\n";
    $cursor->tape_write($self->colour);
    $cursor->move_forward($self->rotation);
}

sub glyphs {
    return qw/W/;
}
no Moose;
__PACKAGE__->meta->make_immutable;

