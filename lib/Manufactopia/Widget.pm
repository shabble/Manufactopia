package Manufactopia::Widget;

use Carp;
use Moose;

# assume the default output (0deg rotation) is to the south.
# North: x, y-1
# East : x+1, y
# South: x, y+1
# West : x-1, y

has 'name' =>
  (
   is      => 'rw',
   isa     => 'Str',
   default => 'Empty Floor',
  );

has 'rotation' =>
  (
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
    return $glyphs[$self->translate_glyph_rotation];
}

sub translate_glyph_rotation {
    my $self = shift;
    my $angle = $self->rotation;

    if (($angle % 90) != 0) {
        carp "Invalid Angle";
    } else {
        return $angle / 90;
    }
}

sub evaluate {
    my ($self, $cursor) = @_;
    # we've been dropped on a floor.
    
    return 'f';
}

sub is_output_widget {
    return 0;
}

no Moose;
__PACKAGE__->meta->make_immutable;

