package Manufactopia::Widget::Conveyor;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

has '+name' => ( default => 'Conveyor' );

sub glyphs {
    return qw/v < ^ >/;
}

sub evaluate {
    my ($self, $cursor) = @_;
    $cursor->move_forward($self->rotation);
}

no Moose;
__PACKAGE__->meta->make_immutable;

