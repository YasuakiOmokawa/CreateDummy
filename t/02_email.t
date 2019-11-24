use strict;
use Test::More 0.98;

use CreateDummy::Email;

subtest q{setupしたデータを外部へ出力} => sub {

  my $time1 = time;
  my $data = CreateDummy::Email->new(number => 7000000);

  ok($data->create, q{セットアップデータ作成}); 

  print $data->get . "\n";
  print $data->get . "\n";
  my $time2 = time;
  my $process_time = $time2 - $time1;
  print "process time: $process_time\n";
};


done_testing;

