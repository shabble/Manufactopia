package Manufactopia::Widget::Input;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

has '+name' => ( default => 'Input' );

sub glyphs {
    return qw/I/;
}

sub evaluate {
    my ($self, $cursor) = @_;
    $cursor->move_forward($self->rotation);
}

no Moose;
__PACKAGE__->meta->make_immutable;

