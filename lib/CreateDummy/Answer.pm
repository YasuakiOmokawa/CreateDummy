package CreateDummy::Answer;
use strict;
use warnings;
use utf8;

use String::Random;

sub new {
  my ($class) = @_;

  bless {
    sr => String::Random->new(),
  }, $class;
}

sub get {
  my ($self) = @_;

  return $self->{sr}->randregex('[a-z]{100}');
}

1;
__END__


