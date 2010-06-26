package Manufactopia::Widget;

use Carp;
use Moose;

has 'rotation'
  => (
      is => 'rw',
      isa => 'Int',
      default => 0,
      # todo: add NESW anglular constraint (%90)
     );

sub glyphs {
    return ("#");
}

sub glyph {
    my $self = shift;

    my @glyphs = $self->glyphs;
    # if something can't be rotated, we'll only specify a single
    # glyph.
    return $glyphs[0] unless scalar(@glyphs) == 4;
    # otherwise send the appropriate glyph for the rotation.
    return $glyphs[_translate_glyph_rotation($self->rotation)];
}

sub _translate_glyph_rotation {
    my ($angle) = @_;
    if (($angle % 90) != 0) {
        carp "Invalid Angle";
    } else {
        return $angle / 90;
    }
}

sub evaluate {
    my ($self, $cursor) = @_;
    $cursor->ypos($cursor->ypos + 1);
    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

