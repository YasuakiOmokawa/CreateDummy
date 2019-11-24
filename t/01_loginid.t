use strict;
use Test::More 0.98;

use CreateDummy::LoginId;

subtest q{setupしたデータを外部へ出力} => sub {

  my $login_id = CreateDummy::LoginId->new(number => 10000);

  ok($login_id->create, q{セットアップデータのサイズを出力}); 

  print $login_id->get . "\n";
  print $login_id->get . "\n";

};


done_testing;

