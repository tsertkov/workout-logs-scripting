#!/usr/bin/env perl

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder::XPath;
use Set::Light;
use POSIX qw(strftime);

sub get_sentences_by_url {
  my ($url) = @_;
  my $ua = LWP::UserAgent->new();
  my $response = $ua->get($url);
  die($response->status_line) if (!$response->is_success);

  my $tree = HTML::TreeBuilder::XPath->new;
  $tree->ignore_unknown();
  $tree->parse($response->decoded_content);
  $tree->eof;

  my @nodes;
  push(@nodes, $tree->findnodes('//div[@id="mw-content-text"]/div[@class="mw-parser-output"]/p'));
  push(@nodes, $tree->findnodes('//div[@id="mw-content-text"]/div[@class="mw-parser-output"]/ul/li'));

  my @sentences;
  for my $node (@nodes) {
    my $line = $node->as_text;
    $line =~ s/\[[^]]+\]//g;
    $line =~ s/^\s+//g;
    $line =~ s/\s+$//g;
    my @lines = split(/\. /, $line);

    for my $line (@lines) {
      next if ($line =~ m/^[^A-Z]/);
      next if (scalar(split(/\s+/, $line)) < 3);
      $line =~ s/[.:]$//;
      push(@sentences, $line);
    }
  }

  return @sentences;
}

sub get_dropped_ticks {
  my ($total_ticks, $max_ticks) = @_;
  my $dropped_ticks_count = $total_ticks - $max_ticks;
  my $ticks = Set::Light->new;

  while ($ticks->size() < $dropped_ticks_count) {
    $ticks->insert(int(rand($total_ticks)));
  }

  return $ticks;
}

my $date_start = 1325376000 + 3600 * 9;
my $date_end = $date_start + 3600 * 3;
my $pad_char = "X";
my $pid_min = 3000;
my $pid_max = 5000;
my $line_length = 500;
my $line_count = 10000;
my $sentences_url = "https://en.wikipedia.org/wiki/Amazon_S3";
my $delimiter = "|";
my @statuses = ("OK", "TEMP", "PERM");

my $ticks = $date_end - $date_start;
my $dropped_ticks = get_dropped_ticks($ticks, $line_count);
my @sentences = get_sentences_by_url($sentences_url);

for (my $tick = 0; $tick < $ticks; $tick++) {
  next if ($dropped_ticks->has($tick));
  my @line = ();
  $line[0] = strftime "%Y%m%d", gmtime($date_start + $tick);
  $line[1] = strftime "%H:%M:%S", gmtime($date_start + $tick);
  $line[2] = int(rand($pid_max - $pid_min + 1)) + $pid_min;
  $line[3] = @statuses[int(rand(scalar(@statuses)))];
  $line[4] = @sentences[int(rand(scalar(@sentences)))] . ".";

  my $line = join('|', @line);
  $line = substr($line, 0, 499) . "|";
  print $line, $pad_char x (500 - length($line)), "\n";
}
