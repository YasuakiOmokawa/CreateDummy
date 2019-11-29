package Match::InnerTable;
use strict;
use warnings;
use utf8;

use CDB_File;
use Carp 'croak';
use FindBin;
use File::Path 'mkpath';
use Fcntl;

sub new {
  my ($class) = @_;

  my $dir = "$FindBin::Bin/../tmp/tmp$$";
  my $file = "${dir}/inner_table.cdb";
  mkpath $dir unless -d $dir;

  my $cdb = new CDB_File ("$file.cdb", "$file.$$")
    or croak "new CDB_File failed $file: $!\n";

  bless {
    table => $cdb,
  }, $class;
}

sub insert {
  my ($self, %params) = @_;

  # データ格納
  $self->{table}->insert($params{key}, $params{value});
}

sub get {
  my ($self, $key) = @_;

  my $v = undef;
  if ($self->{table}->EXISTS($key)) {
      $v = $self->{table}->FETCH($key);
  }

  return $v;
}

1;
__END__

  $cdb->finish;
