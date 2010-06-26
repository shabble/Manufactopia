package Manufactopia::Tile;

use Moose;
use Manufactopia::Widget::Conveyor;

has 'contents'
  => (
      is => 'rw',
      isa => 'Maybe[Manufactopia::Widget]',
     );

sub glyph {
    my $self = shift;

    my $widget = $self->contents;

    if (defined $widget) {
        return $widget->glyph;
    } else {
        return '#';
    }
}
no Moose;
__PACKAGE__->meta->make_immutable;
