package Manufactopia::Widget::Input;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

sub glyphs {
    return qw/I/;
}
no Moose;
__PACKAGE__->meta->make_immutable;

