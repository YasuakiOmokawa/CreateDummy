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

  bless {
    table => {},
  }, $class;
}

sub insert {
  my ($self, %params) = @_;

  # データ格納
  $self->{table}{$params{key}} = $params{value};
}

sub get {
  my ($self, $key) = @_;

  my $v = undef;
  if (exists $self->{table}{$key}) {
      $v = $self->{table}{$key};
  }

  return $v;
}

1;
__END__

