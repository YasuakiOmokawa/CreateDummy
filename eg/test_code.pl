use strict;
use warnings;
use utf8;

use Data::Dumper;

my $href = {
  k1 => 'hoge',
  k2 => 'fuga',
  k3 => 'hogefuga',
};

# my @arr = keys(%{$href});
# print Dumper \@arr;

# print Dumper each(%{$href});

my ($key, $address) = each(%{$href});
print $key . "\n";
print $address . "\n";