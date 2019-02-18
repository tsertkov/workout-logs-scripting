#!/usr/bin/env perl

use strict;
use warnings;
use DateTime::Format::Strptime;
use GD::Graph::bars;
use POSIX qw(strftime);

sub stdin_to_stats {
  my $format = DateTime::Format::Strptime->new(
    pattern => '%Y%m%d %H:%M:%S'
  );

  my @stats;
  my $minute_row = {};

  while (<STDIN>) {
    chomp($_);
    my ($date, $time, $pid, $status) = split(/\|/, $_, 5);
    my $minute = int($format->parse_datetime("$date $time")->epoch / 60);

    if ($minute_row->{minute} && $minute != $minute_row->{minute}) {
      push(@stats, $minute_row);
      $minute_row = {};
    }

    $minute_row->{minute} = $minute;
    $minute_row->{$status}++;
  }

  push(@stats, $minute_row);
  return @stats;
}

my @data = ();
for my $minute_row (stdin_to_stats()) {
  my $time = $minute_row->{minute} * 60;
  push(@{$data[0]}, strftime("%H:%M", gmtime($time)));
  push(@{$data[1]}, $minute_row->{OK});
  push(@{$data[2]}, $minute_row->{TEMP});
  push(@{$data[3]}, $minute_row->{PERM});
  push(@{$data[4]}, 60 - $minute_row->{OK} - $minute_row->{TEMP} - $minute_row->{PERM});
}

my $graph = GD::Graph::bars->new(960, 320);
$graph->set(
  dclrs             => [('#24BC14', '#ECD748', '#EA644A', '#000000')],
  cumulate          => 1,
  y_label           => 'Msg per minute',
  y_plot_values     => 0,
  y_max_value       => 60,
  x_label_skip      => 5,
  x_labels_vertical => 1,
  transparent       => 0,
) or die $graph->error;

print $graph->plot(\@data)->png;
