use strict;
use warnings;
use utf8;

use Data::Dumper;

sub create_data {

  # csvレコード作成
  my $id = 1;
  my $email = 'djskalda@ymir.co.jp';
  my $smtp_res = 200;
  my $datetime = '2012/07/01 19:00:00';
  my $login_name = 'btnaqd';
  my $answer = 'q9ldgwdr147lf2j6g0wsfl9oubeyt5bnomfc3xy09zx0aks81hn6dck993f6lwingho88xd56fp9pdec8f2oilbj32lrqxv1yekr';

  my @csv_data = ($id, $email, $smtp_res, $datetime, $login_name, $answer);

  return @csv_data;
}

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
 