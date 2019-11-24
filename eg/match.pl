use strict;
use warnings;
use utf8;

use Tie::File;
use FindBin;
use File::Path 'mkpath';

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
  my $row_size2 = scalar(@array2) - 1;
  my $row_size1 = scalar(@array1) - 1;

  # 1回で比較する行のバッチサイズ
  my $batch_size = 500_000;

  # 余白サイズ
  my $safe_space2 = 100;
  my $safe_space1 = $safe_space2 * 2;

  # 走査ポインタ(内部表用) ※0が1行目！
  my $row_begin2 = 0;
  my $row_end2   = $batch_size;

  # 走査ポインタ(駆動表用) ※0が1行目！
  my $row_begin1 = 0;
  my $row_end1   = $batch_size;

  # チェック完了フラグ
  my $done_2 = 0;
  my $done_1 = 0;

  # マッチした行の数
  my $counter = 0;

  # チェック開始
  while(1) {

    # 内部表を宣言
    my %hash;

    # 内部表である2のデータベースを作成
    for my $i ($row_begin2..$row_end2) {

      my $line2 = $obj2->FETCH($i);
      chomp $line2;
      my ($id, $email, $smtp, $datetime, $login_id2) = split /,/, $line2;

      $hash{$login_id2} = $i;
      print "inner table setup, now row num -> $i\n";

      # ファイルの行数を超えたらループを抜ける
      if ($i >= $row_size2) {
        $done_2 = 1;
        last;
      }
    }

    # 駆動表である1でチェック
    for my $i ($row_begin1..$row_end1) {

      my $line1 = $obj1->FETCH($i);
      my ($id, $email, $smtp, $datetime, $login_id1) = split /,/, $line1;

      # 一致したら書きだす
      if (exists $hash{$login_id1}) {
        print $o_fh "file1," . $line1 . "\n";
        print $o_fh "file2," . $obj2->FETCH($hash{$login_id1}) . "\n";
        print "match record number -> ${i}, login id -> $login_id1\n";
        $counter++;
      }

      # ファイルの行数を超えたらループを抜ける
      if ($i >= $row_size1) {
        $done_1 = 1;
        last;
      }
    }

    # どちらのファイルもチェック完了すれば終了
    last if $done_1 && $done_2;

    # 完了してないなら、次のチェックに向けてポインタをセット
    # チェック漏れを防ぐため、余白サイズを引いた行番号から再度走査する
    undef %hash; # 内部表をクリア
    $row_begin2 = $row_end2 - $safe_space2;
    $row_end2  += $batch_size;

    $row_begin1 = $row_end1 - $safe_space1;
    $row_end1  += $batch_size;
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
