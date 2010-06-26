package Manufactopia::Widget::Output;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';

has '+name' => ( default => 'Output' );

sub glyphs {
    return qw/O/;
}

sub evaluate {
    my ($self, $cursor) = @_;
    return 'O';
}

no Moose;
__PACKAGE__->meta->make_immutable;

