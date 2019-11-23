use strict;
use warnings;
use utf8;

use Data::Dumper;

use CreateDummy::SMTPResCode;

my $smtp = CreateDummy::SMTPResCode->new;
for my $i (1..7000000) {
  $smtp->get;
  # print "smtp code -> " . $smtp->get . "\n";
}

__END__

use CreateDummy::CreateEmail;

my $email = CreateDummy::CreateEmail->new(
  number => 1_000,
  # number => 7_000_000,
);
$email->_setup_domains;
# print Dumper $email->{domains};

my $all_nums = 0;
for my $k (keys %{$email->{domains}}) {
  # print "domain ${k} is valid limit number\n" if $email->{domains}{$k} >= 10;
  $all_nums += $email->{domains}{$k};
};
print "all domains number -> ${all_nums}\n";

$email->_setup_addresses;
# for my $k (keys %{$email->{addresses}}) {
my $num = keys %{$email->{addresses}};
# print Dumper $email->{addresses};
print "all addresses number -> ${num}\n";

my $a = $email->get;
print "get email -> $a\n";
my $num = keys %{$email->{addresses}};
print "2nd addresses number -> ${num}\n";

my $a = $email->get;
print "get email -> $a\n";
my $num = keys %{$email->{addresses}};
print "3rd addresses number -> ${num}\n";
