#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use utf8;
use Data::Dumper;
use Getopt::Long;
use JSON;
use Net::Twitter;
use File::Slurper qw(write_text);
binmode(STDOUT, ":encoding(UTF-8)");

my $consumer_key;
my $consumer_secret;
my $access_token;
my $access_token_secret;
my $opt_accounts;
my $result = GetOptions(
    'consumer-key=s'         => \$consumer_key,
    'consumer-secret=s'      => \$consumer_secret,
    'access-token=s'         => \$access_token,
    'access-token-secret=s'  => \$access_token_secret,
    'accounts=s'             => \$opt_accounts,
);

my $tweets_per_account = 300;
my @accounts = split(/,/,$opt_accounts);
my $json = JSON->new;
$json->allow_nonref;
$json->pretty;

my $tweets = get_tweets();
my $tweets_json = $json->encode( $tweets );
write_text('fresh_tweets.json', $tweets_json);

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
          count => $tweets_per_account,
      };
      my $r = $nt->user_timeline( $search_hash );
      foreach my $status ( @$r ) {
        push @tweets, {
          text => $status->{text},
          url => "https://twitter.com/$account/status/$status->{id_str}"
        };
      }
  }
  return \@tweets;
}

exit(0);
