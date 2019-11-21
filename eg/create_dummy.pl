use strict;
use warnings;
use utf8;

print "ファイルサイズがあるバイトを超えたら出力をとめる。\n";

my $dir = "output";
mkdir $dir unless -d $dir;

my $file = "$dir/output_$$.txt";
if (-e "$file") {
  die "$file は存在します。\n";
}

open my $fh, ">", $file
  or die "File open error : $!";

while (-s $file < 1_000_000_000) {
  my $string = ('a' x 99) . "\n";
  print $fh $string;
}

my $size = -s $file;
print "出力後の $file のファイルサイズは、${size}バイトです。\n";

close $fh;