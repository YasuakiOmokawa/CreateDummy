use strict;
use warnings;
use utf8;

use Data::Dumper;

# use CreateDummy::Email;
# use CreateDummy::SMTPResCode;
# use CreateDummy::Datetime;
# use CreateDummy::LoginId;
# use CreateDummy::Answer;

use CreateDummy;

my $limit = 1024*1024*1024;
my $row_numbers = int(($limit / 157) * 1.1);
print "predicate data size -> " . $limit . "\n";
print "predicate row numbers -> " . $row_numbers . "\n";

sleep 5;

my $time1 = time;

my $dummy = CreateDummy->new(
  number => $row_numbers,
);

$dummy->setup;

my $size = 0;
my $counter = 0;
while ($limit > $size) {
  my $str = $dummy->create;
  print "data -> " . $str;
  $size += length $str;
  $counter++;
}

print "\n";
print "predicted data size -> " . $limit . "\n";
print "predicted row numbers -> " . $row_numbers . "\n";
print "--------------------------\n";
print "result data size -> " . $size . "\n";
print "result row count -> " . $counter . "\n";

my $time2 = time;
my $process_time = $time2 - $time1;
print "exec time -> " . $process_time . "\n";
__END__

for my $i (1..7_000_000) {
  print "date -> ". $datetime->get . "\n";
}

# my $smtp = CreateDummy::SMTPResCode->new;
# my $answer = CreateDummy::Answer->new;
my $login = CreateDummy::LoginId->new(
  number => 7000000,
);
my $time1 = time;

$login->create;

my $nums = keys %{$login->{ids}};
print "nums -> " . $nums . "\n";

print "id -> " . $login->get . "\n";
$nums = keys %{$login->{ids}};
print "nums -> " . $nums . "\n";

print "id -> " . $login->get . "\n";
$nums = keys %{$login->{ids}};
print "nums -> " . $nums . "\n";

my $time2 = time;
my $process_time = $time2 - $time1;
print "exec time -> " . $process_time . "\n";


# my $smtp = CreateDummy::SMTPResCode->new;
my $answer = CreateDummy::Answer->new;
my $time1 = time;
for my $i (1..100000) {
  $answer->get;
  # print "answer -> " . $answer->get . "\n";
  # print "smtp code -> " . $smtp->get . "\n";
}
my $time2 = time;
my $process_time = $time2 - $time1;
print "exec time -> " . $process_time . "\n";

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
