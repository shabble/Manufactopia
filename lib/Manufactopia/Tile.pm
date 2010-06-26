package Manufactopia::Tile;

use Carp;
use Moose;
use Manufactopia::Widget::Conveyor;

has 'contents'
  => (
      is => 'rw',
      isa => 'Maybe[Manufactopia::Widget]',
     );
has 'rotation'
  => (
      is => 'rw',
      isa => 'Int',
      default => 0,
      # todo: add NESW anglular constraint (%90)
     );

sub glyph {
    my $self = shift;

    my $widget = $self->contents;

    if (defined $widget) {
        my @glyphs = $widget->glyphs;
        # if something can't be rotated, we'll only specify a single
        # glyph.
        return $glyphs[0] unless scalar(@glyphs) == 4;
        # otherwise send the appropriate glyph for the rotation.
        return $glyphs[_translate_glyph_rotation($self->rotation)];
    } else {
        # default.
        return '#';
    }
}

sub _translate_glyph_rotation {
    my ($angle) = @_;
    if (($angle % 90) != 0) {
        carp "Invalid Angle";
    } else {
        return $angle / 90;
    }
}
no Moose;
__PACKAGE__->meta->make_immutable;
