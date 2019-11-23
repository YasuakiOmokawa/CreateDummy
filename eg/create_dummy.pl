use strict;
use warnings;
use utf8;

use Data::Dumper;
use CreateDummy;

# main処理
eval {
  my $start_time = time;

  my $dir = "output";
  mkdir $dir unless -d $dir;

  my $file = "$dir/output_$$.csv";
  if (-e "$file") {
    die "$file は存在します。\n";
  }

  # ファイルオープン
  open my $fh, ">", $file
    or die "File open error : $!";

  # 書き込み（シングル : 13secくらい）
  binmode $fh;
  my $size = 0;
  my $limit = 1024 * 1024 * 1024;
  while ($size < $limit) {
    my $string = join(",", create_data()) . "\n";
    print $fh $string;
    $size += length $string;
  }

  # ファイルクローズ
  close $fh;

  # 実行時間出力
  my $end_time = time;
  my $process_time = $end_time - $start_time;
  print "process time: ${process_time}\n";

  # 出力ファイルサイズ出力
  my $file_size = -s $file;
  print "After output $file size -> ${file_size} bytes\n";
 };
 if($@) {
   print "Error: $@\n";
 }
 