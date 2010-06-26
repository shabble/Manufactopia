package Manufactopia::Widget::Conveyor;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

sub glyphs {
    return qw/^ > V </;
}
no Moose;
__PACKAGE__->meta->make_immutable;

