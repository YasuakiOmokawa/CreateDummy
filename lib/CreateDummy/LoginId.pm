package CreateDummy::LoginId;
use strict;
use warnings;
use utf8;

use String::Random;

sub new {
  my ($class, %params) = @_;

  bless {
    number => $params{number},
    ids => {},
  }, $class;
}

sub create {
  my ($self) = @_;

  my $sr = String::Random->new;

  for my $number (1..$self->{number}) {

    #  英小文字6桁の重複なしランダム文字列を生成
    my $str = "";
    while(1) {
      $str = $sr->randregex('[a-z]{6}');

      # 生成した文字列が一意である場合は文字列を格納
      unless (exists $self->{ids}{$str}) {
        $self->{ids}{$str} = "";
        last;
      }
    }
  }
}

sub get {
  my ($self) = @_;

  my ($k, $v) = each %{$self->{ids}};

  delete $self->{ids}{$k};

  return $k;
}

1;
__END__


