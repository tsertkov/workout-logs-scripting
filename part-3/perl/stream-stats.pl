#!/usr/bin/env perl

use strict;
use warnings;

my %stats;
while (<STDIN>) {
  chomp($_);
  my ($date, $time, $pid, $status, $msg) = split(/\|/, $_, 5);
  $msg =~ s/\|X*$//;
  $stats{$_}++ foreach ($msg =~ /\w+/g);
}

print "Word\tFrequency\n";
print($_, "\t", $stats{$_}, "\n") foreach ((sort {$stats{$b} <=> $stats{$a}} keys %stats)[0..9]);
