package Manufactopia::ConfigParser;

use Moose;
use YAML::Any;
use Data::Dumper;

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

sub widget_cost {
    my ($self, $widget_type, $widget_colour) = @_;
    my $w = $self->widget_get($widget_type, $widget_colour);
    return $w->{cost};
}

sub widget_get {
    my ($self, $widget_type, $widget_colour) = @_;
    my $permitted_widgets = $self->get('permitted_widgets');
    $widget_colour //= '';

    foreach my $widget (@$permitted_widgets) {
        my $type = [ keys %$widget ]->[0];

        if ($widget_type eq $type) {

            my $colour = $widget->{$type}->{colour} // '';
            if ($widget_colour eq $colour) {

                return $widget->{$type};
            }
        }
    }
    return undef;
}

sub is_permitted_widget {
    my ($self, $widget_type, $widget_colour) = @_;
    my $w = $self->widget_get($widget_type, $widget_colour);
    if ($w) {
        return 1;
    } else {
        return 0;
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;


