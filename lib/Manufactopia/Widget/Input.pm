package Manufactopia::Widget::Input;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

sub glyph {
    return '>';
}
no Moose;
__PACKAGE__->meta->make_immutable;

