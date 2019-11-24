package CreateDummy::LoginId;
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
    ids => {},
    sr => String::Random->new,
  }, $class;
}

sub get {
  my ($self) = @_;

  while (my $line = readline $self->{fh}) {
    chomp $line;
    return $line;
  };
}

sub create {
  my ($self) = @_;

  $self->_setup;
}

# 英小文字6桁の重複なしランダム文字列を中間ファイルに出力
sub _setup {
  my ($self) = @_;

  my $store_dir = "$FindBin::Bin/../tmp/tmp$$";
  mkpath $store_dir unless -d $store_dir;

  my $store_file = "${store_dir}/loginid.txt";
  open my $fh, ">", $store_file
    or croak "File open error : $!";

  for my $i (1..$self->{number}) {
    my $str = $self->{sr}->randregex('[a-z]{6}');
    print $fh $str . "\n";
    print "login id -> ${str}\n";
  }
  close $fh;

  my $uniq_file = "${store_file}.uniq";

  my $cmd = "sort $store_file | uniq > $uniq_file";
  system($cmd) == 0 or croak "Command Error $cmd : $!";

  open my $fh_u, "<", $uniq_file
    or croak "File open error : $!";
  
  $self->{fh} = $fh_u;
}

1;
__END__


