package Manufactopia::Tile;

use Carp;
use Moose;
use Manufactopia::Widget::Conveyor;

has 'contents'
  => (
      is => 'rw',
      isa => 'Maybe[Manufactopia::Widget]',
     );


no Moose;
__PACKAGE__->meta->make_immutable;
