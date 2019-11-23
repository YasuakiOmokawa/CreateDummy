use strict;
use warnings;
use utf8;

use Data::Dumper;

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
  open my $fh1, "<", $file1
    or die "File open error : $!";
  # binmode $fh1;

  # 検索用ハッシュへ片方のファイルを取り込み
  my %seek = ();

  open my $fh2, "<", $file2
    or die "File open error : $!";
  
  while (my $line2 = readline $fh2) {
    chomp $line2;
    my ($id2, $email2, $smtp2, $datetime2, $login_name2) = split /,/, $line2, 5;
    $seek{$login_name2} = $line2;
  }
  close $fh2;

  while (my $line1 = readline $fh1) {

    chomp $line1;
    my ($id1, $email1, $smtp1, $datetime1, $login_name1) = split /,/, $line1, 5;

    if (exists $seek{$login_name1}) {
      print $o_fh $line1 . "\n";
      print $o_fh $seek{$login_name1} . "\n";
      print $o_fh "---------------------\n";
      print "match file record\n";
    }
  }
  close $fh1;

  # 書き込みファイルクローズ
  close $o_fh;

  # 実行時間出力
  my $end_time = time;
  my $process_time = $end_time - $start_time;
  print "process time: ${process_time}\n";

 };
 if($@) {
   print "Error: $@\n";
 }
 
 __END__

    # $seek->{$login_name1} = $.;
    # $seek->{$login_name1} = [$offset, $byte];

    # 次の行の位置までオフセットを移動
    # $offset += $byte;

    # print "login -> ${login_name1}, offset -> ${offset}, byte -> ${byte}\n";

# use open qw/:utf8/;
# use File::Slurp;

# my @text = read_file($file1);


  # print Dumper $seek;

  #  while (my $line1 = readline $fh1) {

  #   chomp $line1;
  #   open my $fh2, "<", $file2
  #     or die "File open error : $!";
 
  #   while (my $line2 = readline $fh2) {

  #     chomp $line2;
  #     my ($id1, $email1, $smtp1, $datetime1, $login_name1) = split /,/, $line1;
  #     my ($id2, $email2, $smtp2, $datetime2, $login_name2) = split /,/, $line2;

  #     # ログイン文字列が完全一致した行を出力
  #     if ($login_name1 eq $login_name2) {
  #       print $o_fh $line1 . "\n";
  #       print $o_fh $line2 . "\n";
  #       print $o_fh "---------------------\n";
  #       last;
  #     }
  #   }
  #   close $fh2;
  # }
  # close $fh1;



