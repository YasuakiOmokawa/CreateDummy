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
    die "$file is exist\n";
  }

  # ファイルオープン
  open my $fh, ">", $file
    or die "File open error : $!";

  # 書き込み
  binmode $fh;
  my $size = 0;
  my $counter = 0;

  # 作成したいファイルサイズ
  my $limit_size = ARGV[0];

  # 作成予定行数。重複がいくつかあることを想定し、実際の行数より少し多めにする
  my $row_numbers = int($limit_size / 160);

  my $dummy = CreateDummy->new(
    number => $row_numbers,
  );

  $dummy->create;

  while ($size < $limit_size) {
    my $string = $dummy->get;
    print $fh $string;
    $size += length $string;
    $counter++;
  }

  # ファイルクローズ
  close $fh;

  print "\n";
  print "predicted data size -> " . $limit_size . "\n";
  print "predicted row numbers -> " . $row_numbers . "\n";
  print "--------------------------\n";
  print "result data size -> " . $size . "\n";
  print "result row count -> " . $counter . "\n";

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
 