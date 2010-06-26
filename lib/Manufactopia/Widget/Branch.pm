package Manufactopia::Widget::Branch;

use Moose;
use Manufactopia::Widget;

extends 'Manufactopia::Widget';
has '+name' => ( default => 'Branch' );

has 'colour' =>
  (
   is  => 'rw',
   isa => 'Str',
   required => 1,
  );

sub glyphs {
    return qw/R/;
}
sub evaluate {
    my ($self, $cursor) = @_;
    # we don't want to remove a token if it's
    # something that is ignored by this brancher.
    # So peek at it first.
    my $token = $cursor->tape_peek;

    my $match = index($self->colour, $token);
    if ($match >= 0) {
        # consume the token
        $cursor->tape_read;
        # use the index of the match to decide if we go left
        # or right. so RB is the 'flip' of BR.

        if ($match == 0) {
            $cursor->move_left;
        } else {
            $cursor->move_right;
        }
    } else {
        $cursor->move_forward;
    }
}
no Moose;
__PACKAGE__->meta->make_immutable;

