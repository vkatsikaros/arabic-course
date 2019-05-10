#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use utf8;
use Data::Dumper;
use JSON;
use File::Slurper qw( read_text write_text);
binmode(STDOUT, ":encoding(UTF-8)");

my $stopwords =  read_word_lists('stopwords');
my $location_names = read_word_lists('location_names');
my $people_names = read_word_lists('people_names');
my $common_silly = read_word_lists('common_silly');

my $json = JSON->new;
$json->allow_nonref;
$json->pretty;

my $tweets = read_tweets();
my $processed_tweets = process_tweets($tweets);
my $tweets_json = $json->encode( $processed_tweets );
write_text('processed_tweets.json', $tweets_json);
say "ok";

sub read_word_lists
{
  my ($file) = @_;
  my %words;
  my $txt = read_text("data/$file.txt");
  my @lines = split(/\n/, $txt);
  foreach my $line (@lines) {
    my @tokens = split(/\,/, $line);
    $words{ $tokens[0] } = 1;
  }
  return \%words;
}

sub read_tweets
{
  my $txt = read_text('fresh_tweets.json');
  my $decoded = $json->decode( $txt );
  return $decoded;
}

sub process_tweets
{
  my $tweets = shift;
  my %words;
  my %count;
  foreach my $tweet ( @{$tweets} ) {
      my $t = $tweet->{text};

      # remove all punctuation
      $t =~ s/\p{General_Category=Punctuation}/ /g;
      # remove everything not in the arabic unicode block
      $t =~ s/\P{Block=Arabic}/ /g;
      # compact whitespace
      $t =~ s/\s+/ /g;
      $t =~ s/^\s+//g;
      $t =~ s/\s+$//g;
      $tweet->{text_clean} = $t;

      my @tweet_words = split(/\s/, $t);

      foreach my $i ( @tweet_words ) {
          next if( $i =~ m/^https/ );
          next if( $i =~ m/^\d+$/ );
          # hashtags sometimes include underscores. Convert it to whitespace
          # and leave it as is
          $i =~ s/_/ /;

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
          if( $common_silly->{$i} ) {
            $count{common_silly}++;
            next;
          }
          $words{$i}++;
          $count{word}++;
          $tweet->{words}->{$i}++;
      }
  }

  return {
    tweets => $tweets,
    counters => \%count,
    words => \%words,
  };
}

exit(0);
