package CreateDummy;
use strict;
use warnings;
use utf8;

use Data::Dumper;

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
    login_name => CreateDummy::LoginId->new,
    answer => CreateDummy::Answer->new,
  }, $class;
}

sub setup {
  my ($self) = @_;

  # 一意なデータを生成
  $self->{email}->create;
}

sub create {
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

  return join(",", @csv_data) . "\n";
}

1;
__END__