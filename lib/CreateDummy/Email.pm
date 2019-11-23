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
    sr => String::Random->new(),
  }, $class;
}

sub create {
  my ($self) = @_;

  $self->_setup_domains;
}

sub get {
  my ($self) = @_;

  #  英小文字8 ~ 12桁の重複なしランダム文字列を生成
  my $str = $self->{sr}->randregex('[a-z]{8,12}');

  while(1) {
    my ($k, $v) = each %{$self->{domains}};

    if ($k) {
      if ($v > 0) {
        # ドメイン作成上限を一つ減らす
        $self->{domains}{$k}--;
        return $str . '@' . $k; # Emailアドレス
      } else {
        # 作成上限を超えたドメインは削除
        delete $self->{domains}{$k};
        next;
      }
      print "domain -> ${k}, number -> ${v}\n";
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
    my $num = int(rand 91) + 10;
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


