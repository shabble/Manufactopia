package Manufactopia::Cursor;

use Carp;
use Moose;

has 'xpos' =>
  (
   is  => 'rw',
   isa => 'Int',
  );

has 'ypos' =>
  (
   is  => 'rw',
   isa => 'Int',
  );

has 'tape' =>
  (
   is  => 'rw',
   isa => 'ArrayRef[Str]',
   traits  => ['Array'],
   default => sub { [ ] },
   handles =>
   {
    tape_write => 'push',
    tape_read  => 'shift',
   },
  );

sub move {
    my ($self, $x, $y) = @_;
    $self->xpos($x);
    $self->ypos($y);
}
sub draw {
    my $self = shift;
    return '[' . join(', ', @{$self->tape}) . ']';
}
# sub tape_write {
#     my ($self, $colour) = @_;
#     $self->
# }

no Moose;
__PACKAGE__->meta->make_immutable;
