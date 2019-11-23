package CreateDummy::SMTPResCode;
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

  return $self->{sr}->randregex('[1-5][0-5][0-9]');
}

1;
__END__


