package Manufactopia::Widget::Branch;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

sub glyphs {
    return qw/^ > V </;
}
no Moose;
__PACKAGE__->meta->make_immutable;

