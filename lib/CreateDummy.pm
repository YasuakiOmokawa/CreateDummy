package CreateDummy;
use strict;
use warnings;
use utf8;

use CreateDummy::Email;
use CreateDummy::SMTPResCode;
use CreateDummy::Datetime;
use CreateDummy::LoginId;
use CreateDummy::Answer;

sub new {
  my ($class, %params) = @_;

  bless {
    number => $params{number},
    id => 1,
    email => CreateDummy::Email->new(number => $params{number}),
    smtp => CreateDummy::SMTPResCode->new,
    datetime => CreateDummy::Datetime->new,
    login_name => CreateDummy::LoginId->new(number => $params{number}),
    answer => CreateDummy::Answer->new,
  }, $class;
}

sub create {
  my ($self) = @_;

  # 一意なデータを生成
  $self->{email}->create;
  $self->{login_name}->create;
}

sub get {
  my ($self) = @_;

  my @csv_data = (
    $self->{id},
    $self->{email}->get,
    $self->{smtp}->get,
    $self->{datetime}->get,
    $self->{login_name}->get,
    $self->{answer}->get,
  );

  $self->{id}++;

  my $record = join(",", @csv_data);
  print "data record -> $record\n";
  return $record . "\n";
}

1;
__END__