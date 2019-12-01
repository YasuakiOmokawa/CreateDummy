use strict;
use Test::More 0.98;

use Tie::File;
use FindBin;
use Match::InnerTable;

# subtest q{データベースを作成} => sub {

#   my $time1 = time;

#   # 読み込みファイルオープン
#   my $file = "$FindBin::Bin/file/dummy_1gb.csv";
#   my $obj = tie(my @array, 'Tie::File', $file, memory => 20_000_000) # 読み込みキャッシュbyte変更
#     or die "File tie error : $!";

#   my $inner_table = Match::InnerTable->new;

#   ok(1, q{セットアップデータ作成});

#   my $limit = @array;
#   for my $i (0..$limit-1) {
#     my $line = $obj->FETCH($i);
#     chomp $line;
#     my ($id, $email, $smtp, $datetime, $login_id) = split /,/, $line;

#     $inner_table->insert(key => $login_id, value => $i);
#     print "inner table setup, now row num -> $i\n";
#   }

#   print $inner_table->get . "\n";
#   print $inner_table->get . "\n";

#   my $time2 = time;
#   my $process_time = $time2 - $time1;
#   print "process time: $process_time\n";
# };

subtest q{辞書ファイルを作成} => sub {
  use Data::Dumper;

  my %dic = ();
  @dic{('a' .. 'z')} = (0..25);

  for my $k (sort keys %dic) {
    print "$k -> $dic{$k}\n";
  }

  ok(1, q{作成完了});
};


done_testing;

