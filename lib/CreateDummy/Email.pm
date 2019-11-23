package CreateDummy::Email;
use strict;
use warnings;
use utf8;

use String::Random;

sub new {
  my ($class, %params) = @_;

  bless {
    number => $params{number},
    domains => {},
    addresses => {},
  }, $class;
}

sub create {
  my ($self) = @_;

  $self->_setup_domains;
  $self->_setup_addresses;
}

sub get {
  my ($self) = @_;

  my ($k, $v) = each %{$self->{addresses}};

  delete $self->{addresses}{$k};

  return $v;
}

sub _setup_addresses {
  my ($self) = @_;

  my $sr = String::Random->new();

  for my $k (keys %{$self->{domains}}) {

    for my $nums (1..$self->{domains}{$k}) {

      my $str = "";

      #  英小文字8 ~ 12桁の重複なしランダム文字列を生成
      while(1) {
        $str = $sr->randregex('[a-z]{8,12}');

        # 生成した文字列が一意である場合は文字列を格納
        unless (exists $self->{addresses}{$str}) {
          $self->{addresses}{$str} = "";
          last;
        }
      }

      # Emailアドレス（生成した文字列 + @ + ドメイン格納ハッシュのキー）を格納
      $self->{addresses}{$str} = $str . '@' . $k;
      # print "address count ${nums} -> $self->{addresses}{$str}\n";
    }
  }
}

sub _setup_domains {
  my ($self) = @_;

  my $n = $self->{number};

  # ドメイン別に、生成するアドレス数を格納
  $self->{domains}{'ymir.co.jp'} = int($n * 0.3);
  $self->{domains}{'cuenote.jp'} = int($n * 0.2);
  $self->{domains}{'tripletail.jp'} = int($n * 0.1);

  # ランダム文字列のアドレスを生成
  my $limit = int($n * 0.4);
  my $sr = String::Random->new();
  $sr->{l} = ['jp', 'co.jp'];

  while(1) {
    my $domain = "";
    while(1) {
      # 4 ~ 10文字の英字小文字 + '.jp|.co.jp' でドメイン文字列を生成
      $domain = $sr->randregex('[a-z]{4,10}') . '.' . $sr->randpattern('l');

      # 生成した文字列が一意である場合は文字列を格納
      unless (exists $self->{domains}{$domain}) {
        $self->{domains}{$domain} = "";
        last;
      }
    }
    # 生成されるアドレスの個数を決定
    my $num = int(rand 90) + 10;
    $self->{domains}{$domain} = $num;

    # 生成数の限界を超えたら終了
    $limit -= $num;
    if ($limit < 0) {
      last;
    }
  }
}

1;
__END__


