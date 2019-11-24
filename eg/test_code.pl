use strict;
use warnings;
use utf8;

# main処理
eval {
  my $start_time = time;

  my $file = $ARGV[0];

  # 読み込みファイルオープン
  open my $fh, "<", $file
    or die "File open error : $!";

  # 集計ハッシュ
  my $summary = {};

  # 読み込み
  while (my $line = readline $fh) {
    chomp $line;

    my ($id, $email, $smtp, $datetime, $login_name) = split /,/, $line;

    # email集計
    if (exists $summary->{$email}) {
      $summary->{$email}++;
    } else {
      $summary->{$email} = 1;
    }

    # login_name集計
    if (exists $summary->{$login_name}) {
      $summary->{$login_name}++;
    } else {
      $summary->{$login_name} = 1;
    }

  }

  # 読み込みファイルクローズ
  close $fh;

  my $dir = "output";
  my $o_file = "$dir/summary_$$.csv";

  # ファイル存在チェック
  if (-e "$o_file") {
    die "$o_file is exist\n";
  }

  # 書き込みファイルオープン
  open my $o_fh, ">", $o_file
    or die "File open error : $!";

  # 値の降順ソートで書き込み
  for my $k (reverse sort { %$summary{$a} <=> %$summary{$b} } keys %$summary) {
    my $out = $k . ',' . $summary->{$k} . "\n";
    print $o_fh $out;
  }

  # 書き込みファイルクローズ
  close $fh;

  # 実行時間出力
  my $end_time = time;
  my $process_time = $end_time - $start_time;
  print "process time: ${process_time}\n";

  # 出力ファイル名
  print "Output file -> $o_file\n";

 };
 if($@) {
   print "Error: $@\n";
 }
 