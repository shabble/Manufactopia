package Manufactopia::Widget::Conveyor;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

sub glyph {
    return '>';
}
no Moose;
__PACKAGE__->meta->make_immutable;

