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
    # TODO: only allow this at the beginning, otherwise it counts as floor.
    $cursor->move_forward($self->rotation);
}

no Moose;
__PACKAGE__->meta->make_immutable;

