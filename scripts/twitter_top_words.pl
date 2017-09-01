#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
binmode(STDOUT, ":encoding(UTF-8)");
use Getopt::Long;

use Net::Twitter;

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
my @accounts = split(/,/,$opt_accounts);

my %stopwords = (
    "\N{ARABIC LETTER FEH}\N{ARABIC LETTER YEH}" => 1, # fi
    "\N{ARABIC LETTER MEEM}\N{ARABIC LETTER NOON}" => 1, # min, man, ...
    "\N{ARABIC LETTER AIN}\N{ARABIC LETTER LAM}\N{ARABIC LETTER ALEF MAKSURA}" => 1, # Ala
    "\N{ARABIC LETTER ALEF WITH HAMZA ABOVE}\N{ARABIC LETTER NOON}" => 1, # an
    "\N{ARABIC LETTER ALEF WITH HAMZA BELOW}\N{ARABIC LETTER LAM}\N{ARABIC LETTER ALEF MAKSURA}" => 1, # ila
    "\N{ARABIC LETTER MEEM}\N{ARABIC LETTER AIN}" => 1, # mA
    "\N{ARABIC LETTER AIN}\N{ARABIC LETTER NOON}" => 1, # An
    "\N{ARABIC LETTER BEH}\N{ARABIC LETTER YEH}" => 1, # bi
    "\N{ARABIC LETTER MEEM}\N{ARABIC LETTER ALEF}" => 1, # ma
    "\N{ARABIC LETTER LAM}\N{ARABIC LETTER ALEF}" => 1, # la
    "\N{ARABIC LETTER HEH}\N{ARABIC LETTER LAM}" => 1, # hal
    "\N{ARABIC LETTER HEH}\N{ARABIC LETTER YEH}" => 1, # hia
    "\N{ARABIC LETTER ALEF}\N{ARABIC LETTER LAM}\N{ARABIC LETTER TEH}\N{ARABIC LETTER YEH}" => 1, # alati
    "\N{ARABIC LETTER ALEF}\N{ARABIC LETTER LAM}\N{ARABIC LETTER THAL}\N{ARABIC LETTER YEH}" => 1, # aladi
    "\N{ARABIC LETTER BEH}\N{ARABIC LETTER AIN}\N{ARABIC LETTER DAL}" => 1, # baad
    "\N{ARABIC LETTER NOON}\N{ARABIC LETTER HAH}\N{ARABIC LETTER WAW}" => 1, #nahou
    "\N{ARABIC LETTER WAW}" => 1, #ou
);
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

my %words;
my $word_count;
my $stopword_count;
foreach my $t ( @tweets ) {
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
        if( $stopwords{$i} ) {
            $stopword_count++;
            next;
        }
        $words{$i}++;
        $word_count++;
    }
}
my %stats;
foreach my $w ( sort { $words{$a} <=> $words{$b} } keys %words ) {
    say $words{$w} . ' ' .$w;
    $stats{$words{$w}}++;
}
say "Stats:\noccurences count";
foreach my $i ( sort {$a <=> $b} keys %stats ) {
    say "$i $stats{$i}";
}
say scalar(@tweets)." tweets, $word_count words + $stopword_count stopwords";
exit(0);
