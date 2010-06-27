package Manufactopia::ConfigParser;

use Moose;
use YAML::Any;

use Manufactopia::Widget;

has 'filename' =>
  (
   is  => 'ro',
   isa => 'Str',
   required => 1,
  );

has 'config' =>
  (
   traits  => ['Hash'],
   is      => 'rw',
   isa     => 'HashRef[Any]',
   default => sub { {} },
   handles =>
   {
    get    => 'get',
   },

  );

sub BUILD {
    my $self = shift;
    $self->config(YAML::Any::LoadFile($self->filename));
}

no Moose;
__PACKAGE__->meta->make_immutable;


