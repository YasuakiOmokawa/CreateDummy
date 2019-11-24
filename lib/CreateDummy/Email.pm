package CreateDummy::Email;
use strict;
use warnings;
use utf8;

use Carp 'croak';
use FindBin;
use File::Path 'mkpath';
use String::Random;

sub new {
  my ($class, %params) = @_;

  bless {
    number => $params{number},
    domains => {},
    sr => String::Random->new(),
  }, $class;
}

sub create {
  my ($self) = @_;

  $self->_setup_domains;
  $self->_setup_addresses
}

sub get {
  my ($self) = @_;

  while (my $line = readline $self->{fh}) {
    chomp $line;
    return $line;
  };
}

sub _setup_addresses {
  my ($self) = @_;

  my $store_dir = "$FindBin::Bin/../tmp/tmp$$";
  mkpath $store_dir unless -d $store_dir;

  my $store_file = "${store_dir}/email.txt";
  open my $fh, ">", $store_file
    or croak "File open error : $!";


  # 作成予定数の少ないアドレスの昇順から作成（最低作成数10を保証するため）
  for my $k ( sort { $self->{domains}{$a} <=> $self->{domains}{$b} } keys %{$self->{domains}} ) {

    for my $i (1..$self->{domains}{$k}) {

      #  英小文字8 ~ 12桁のランダム文字列をもつEmailアドレス
      my $email = $self->{sr}->randregex('[a-z]{8,12}') . '@' . $k;
      print "email -> ${email}, limit values -> " . $self->{domains}{$k} . "\n";

      print $fh $email . "\n";
    }
  }
  close $fh;

  my $uniq_file = "${store_file}.uniq";

  my $cmd = "sort $store_file | uniq > $uniq_file";
  system($cmd) == 0 or croak "Command Error $cmd : $!";

  open my $fh_u, "<", $uniq_file
    or croak "File open error : $!";
  
  $self->{fh} = $fh_u;
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


