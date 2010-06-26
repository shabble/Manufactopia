package Manufactopia::Widget::Writer;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

has 'colour' =>
  (
   is  => 'rw',
   isa => 'Str',
  );

sub evaluate {
    my ($self, $cursor) = @_;
    $cursor-
}

sub glyphs {
    return qw/^ > V </;
}
no Moose;
__PACKAGE__->meta->make_immutable;

