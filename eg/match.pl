use strict;
use warnings;
use utf8;

use Tie::File;
use FindBin;
use File::Path 'mkpath';
use Match::InnerTable;

# main処理
eval {
  my $start_time = time;

  my $file1 = $ARGV[0];
  my $file2 = $ARGV[1];

  # 書き込みファイル
  my $dir = "output";
  my $o_file = "$dir/match_$$.csv";

  # ファイル存在チェック
  if (-e "$o_file") {
    die "$o_file is exist\n";
  }

  # 書き込みファイルオープン
  open my $o_fh, ">", $o_file
    or die "File open error : $!";

  # 読み込みファイルオープン
  my $obj1 = tie(my @array1, 'Tie::File', $file1, memory => 20_000_000) # 読み込みキャッシュbyte変更
    or die "File tie error : $!";

  my $obj2 = tie(my @array2, 'Tie::File', $file2, memory => 20_000_000) # 読み込みキャッシュbyte変更
    or die "File tie error : $!";

  # 読み込みファイルの行数
  my $row_size1 = scalar(@array1) - 1;
  my $row_size2 = scalar(@array2) - 1;

  # 追跡インデックス ※0が1行目！
  my $track_index1 = 0;
  my $track_index2 = 0;

  # マッチした行の数
  my $counter = 0;

  # a-zの辞書
  my %dic = ();
  @dic{('a' .. 'z')} = (0..25);
  my $dic_index;

  # a-zの数だけ繰り返し
  for my $i_dic (sort keys %dic) {

    # 内部表作成
    my $inner_table = Match::InnerTable->new;
    for my $i2 ($track_index2..$row_size2) {

      my $line2 = $obj2->FETCH($i2);
      my ($id2, $email, $smtp, $datetime, $login_id2) = split /,/, $line2;

      if (index($login_id2, $i_dic) != 0) {
        $track_index2 = $i2 + 1;
        last;
      };

      # データ挿入
      $inner_table->insert(key => $login_id2, value => $i2);
    }

    # 駆動表と突き合わせ
    for my $i1 ($track_index1..$row_size1) {

      my $line1 = $obj1->FETCH($i1);
      my ($id1, $email, $smtp, $datetime, $login_id1) = split /,/, $line1;

      if (index($login_id1, $i_dic) != 0) {
        $track_index1 = $i1 + 1;
        last;
      };

      # 突き合わせ
      my $v = $inner_table->get($login_id1);
      if ($v) {

        print "match. row1 -> $id1, login id -> $login_id1\n";

        print $o_fh "file1," . $line1 . "\n";
        print $o_fh "file2," . $obj2->FETCH($v) . "\n";

        $counter++;
      }
    }
  }

  # クローズ
  undef $obj1; untie @array1;
  undef $obj2; untie @array2;

  print "\n";
  print "data1 row size -> " . $row_size1 . "\n";
  print "data2 row size -> " . $row_size2 . "\n";
  print "--------------------------\n";
  print "matched row count -> " . $counter . "\n";

  # 実行時間出力
  my $end_time = time;
  my $process_time = $end_time - $start_time;
  print "process time: ${process_time}\n";

 };
 if($@) {
   print "Error: $@\n";
 }

 __END__
