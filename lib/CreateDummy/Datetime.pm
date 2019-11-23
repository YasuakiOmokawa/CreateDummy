package CreateDummy::Datetime;
use strict;
use warnings;
use utf8;

use Time::Local;
use Time::Moment;

sub _to_epoc {
  my ($sec, $min, $hour, $mday, $mon, $year) = @_;
  $year -= 1900;
  $mon--;
  my $time = timelocal($sec,$min,$hour,$mday,$mon,$year);
  return $time;
}

sub new {
  my ($class) = @_;

  my $from_sec = _to_epoc qw( 00 00 00 01 01 1999);
  my $to_sec   = _to_epoc qw( 59 59 23 31 12 2000);
  my $gap = $to_sec - $from_sec;

  bless {
    sr => String::Random->new(),
    from_sec => $from_sec,
    gap => $gap,
  }, $class;
}

sub get {
  my ($self) = @_;

  my $seed = int(rand($self->{gap})) + $self->{from_sec};
  my $tm = Time::Moment->from_epoch($seed);

  return $tm->strftime("%Y/%m/%d %H:%M:%S");
}

1;
__END__


