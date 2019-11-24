package CreateDummy::LoginId;
use strict;
use warnings;
use utf8;

use Carp 'croak';
use FindBin;
use File::Path 'mkpath';
use String::Random;
use Devel::Size qw(size total_size);
use Data::Dumper;

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
    print $fh $self->{sr}->randregex('[a-z]{6}') . "\n";
  }
  close $fh;

  my $uniq_file = "${store_file}.uniq";

  my $cmd = "sort $store_file | uniq > $uniq_file";
  system($cmd) == 0 or croak "Command Error $cmd : $!";

  # 読み書きモードへ
  open my $fh_u, "+<", $uniq_file
    or croak "File open error : $!";
  
  $self->{fh} = $fh_u;
}

sub _setup1 {
  my ($self) = @_;

  use DB_File;

  my $store_dir = "$FindBin::Bin/../tmp/tmp$$";
  mkpath $store_dir unless -d $store_dir;

  my $store_file = "${store_dir}/loginid.db";
  my %db;
  tie (%db, 'DB_File', $store_file) or croak "$!:$store_file";

  for my $i (1..$self->{number}) {
    $db{$self->{sr}->randregex('[a-z]{6}')} = 1;
  }
  # untie %db;
  $self->{db} = \%db;

  # my %db_id;
  # tie (%db_id, 'DB_File', $store_file, O_REDWR, 0777, $DB_HASH)
  #   or "Could not open DBM file $store_file: $!\n";
}

1;
__END__


