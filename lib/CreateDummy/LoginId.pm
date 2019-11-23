package CreateDummy::LoginId;
use strict;
use warnings;
use utf8;

use String::Random;
use Devel::Size qw(size total_size);

sub new {
  my ($class) = @_;

  bless {
    ids => {},
    sr => String::Random->new,
  }, $class;
}

sub get {
  my ($self) = @_;

  #  英小文字6桁の重複なしランダム文字列を生成
  return $self->{sr}->randregex('[a-z]{6}');
}

1;
__END__


