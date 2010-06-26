package Manufactopia::Widget;

use Moose;

sub glyphs {
    return qw/W W W W/;
}

no Moose;
__PACKAGE__->meta->make_immutable;

