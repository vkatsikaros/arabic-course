#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;
use feature 'say';
binmode(STDOUT, ":encoding(UTF-8)");
use Getopt::Long;

use Net::Twitter;
use File::Slurper 'read_text';

my $consumer_key;
my $consumer_secret;
my $access_token;
my $access_token_secret;
my $opt_accounts;
my $opt_latex;
my $opt_stats;
my $result = GetOptions(
    'consumer-key=s'         => \$consumer_key,
    'consumer-secret=s'      => \$consumer_secret,
    'access-token=s'         => \$access_token,
    'access-token-secret=s'  => \$access_token_secret,
    'accounts=s'             => \$opt_accounts,
    'latex'                  => \$opt_latex,
    'stats'                  => \$opt_stats,
);
my $count_threshold = 8;
my @accounts = split(/,/,$opt_accounts);

my $stopwords =  read_word_lists('stopwords');
my $location_names = read_word_lists('location_names');
my $people_names = read_word_lists('people_names');
#print Dumper($location_names); exit;
my $tweets = get_tweets();

# "\N{ARABIC LETTER ALEF}\N{ARABIC LETTER LAM}\N{ARABIC LETTER TEH}\N{ARABIC LETTER YEH}" => 1, # alati

my %words;
my %count;
foreach my $t ( @$tweets ) {
    # compact whitespace
    $t =~ s/\s+/ /g;
    $t =~ s/^\s+//g;
    $t =~ s/\s+$//g;
    my @tweet_words = split(/\s/, $t);

    foreach my $i ( @tweet_words ) {
        next if( $i =~ m/^https/ );
        next if( $i =~ m/^\d+$/ );
        # hashtags sometimes include underscores. Convert it to whitespace
        # and leave it as is
        $i =~ s/_/ /;
        # remove all punctuation
        $i =~ s/\p{General_Category=Punctuation}//g;
        # remove everything not in the arabic unicode block
        $i =~ s/\P{Block=Arabic}//g;
      	next if length($i) == 0; # ignore empty words
        next if $i =~ m/^\W+$/; # ignore non-"word" characters only words
        # ignore common words
        $count{total}++;
        if( $stopwords->{$i} ) {
            $count{stopword}++;
            next;
        }
        if( $location_names->{$i} ) {
          $count{location}++;
          next;
        }
        if( $people_names->{$i} ) {
          $count{people}++;
          next;
        }
        $words{$i}++;
        $count{word}++;
    }
}

my $over_threshold_count;
my $over_threshold_distinct;
foreach my $w ( sort { $words{$a} <=> $words{$b} } keys %words ) {
  if( $words{$w} >= $count_threshold ) {
    $over_threshold_count += $words{$w};
    $over_threshold_distinct++;
  }
}

if( $opt_latex ) {
  say read_text('templates/start_all.tex');
}
say "\\footnotetext[1]{" . scalar(@$tweets). " tweets. Word occurences $count{total}: $count{word} interesting words + $count{stopword} stopwords + $count{location} locations + $count{people} people}";
say "\\footnotetext[2]{This document includes $over_threshold_distinct distinct words ($over_threshold_count occurences) }";

my %stats;
foreach my $w ( sort { $words{$a} <=> $words{$b} } keys %words ) {
    $stats{$words{$w}}++;
    if( $opt_stats ) {
      say $words{$w} . ' ' .$w;
    }
    if( $opt_latex && $words{$w} >= $count_threshold ) {
      say "$words{$w} & & \\ar{ $w } \\\\";
    }
}

if( $opt_latex ) {
  say read_text('templates/end_all.tex');
}

if( $opt_stats ) {
  say "Stats:\noccurences count";
  foreach my $i ( sort {$a <=> $b} keys %stats ) {
      say "$i $stats{$i}";
  }
}

sub read_word_lists
{
  my ($file) = @_;
  my %words;
  my $txt = read_text("data/$file.txt");
  my @lines = split(/\n/, $txt);
  foreach my $line (@lines) {
    my @tokens = split(/\,/, $line);
    #print Dumper(\@tokens);
    $words{ $tokens[0] } = 1;
  }
  return \%words;
}

sub get_tweets
{
  my $nt = Net::Twitter->new(
      traits   => [ qw/ API::RESTv1_1 OAuth / ],
      consumer_key        => $consumer_key,
      consumer_secret     => $consumer_secret,
      access_token        => $access_token,
      access_token_secret => $access_token_secret,
      ssl => 1
  );

  my @tweets;
  foreach my $account ( @accounts ) {
      my $search_hash = {
          screen_name => $account,
          include_rts => 0,
          count => 300,
      };
      my $r = $nt->user_timeline( $search_hash );
      foreach my $status ( @$r ) {
        push @tweets, $status->{text};
      }
  }
  return \@tweets;
}

exit(0);
