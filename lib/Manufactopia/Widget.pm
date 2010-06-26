package Manufactopia::Widget;

use Moose;

sub glyph {
    return 'W';
}

no Moose;
__PACKAGE__->meta->make_immutable;

