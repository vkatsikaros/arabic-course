#!/usr/bin/env perl

# Create and print fake arabic words, used to practice arabic alphabet
# writing

use strict;
use warnings;

use charnames ":full";
use utf8;
binmode STDOUT, ':encoding(UTF8)';

my @consonances = (
{
	name => 'BEH',
	pronounced => 'b',
},
{
	name => 'TEH',
	pronounced => 't',
},
{
	name => 'THEH',
	pronounced => 'θ',
},
{
	name => 'NOON',
	pronounced => 'ν',
},
{
	name => 'SEEN',
	pronounced => 'σ',
},
{
	name => 'SHEEN',
	pronounced => 'sh',
},
{
	name => 'LAM',
	pronounced => 'λ',
},
{
	name => 'KAF',
	pronounced => 'k',
},
{
	name => 'MEEM',
	pronounced => 'μ',
},
{
	name => 'FEH',
	pronounced => 'f',
},
{
	name => 'QAF',
	pronounced => 'q',
},
{
	name => 'HAH',
	pronounced => 'χ',
},
{
	name => 'KHAH',
	pronounced => "\N{LATIN SMALL LETTER H WITH DOT ABOVE}",
},
{
	name => 'JEEM',
	pronounced => 'τζ',
},


{
	name => 'AIN',
	pronounced => 'Α',
},
{
	name => 'GHAIN',
	pronounced => 'γ',
},

{
	name => 'TAH',
	pronounced => 'Τ',
},
{
	name => 'ZAH',
	pronounced => 'Δ',
},
{
	name => 'SAD',
	pronounced => 'Σ',
},
{
	name => 'DAD',
	pronounced => 'γ',
},

{
	name => 'HEH',
	pronounced => 'h',
},


{
	name => 'DAL',
	pronounced => 'ντ',
},
{
	name => 'THAL',
	pronounced => 'δ',
},
{
	name => 'REH',
	pronounced => 'ρ',
},
{
	name => 'ZAIN',
	pronounced => 'ζ',
},

);

my @vowels = (
{
	name => 'ALEF',
	pronounced => 'α',
},
{
	name => 'WAW',
	pronounced => 'ου',
},
{
	name => 'YEH',
	pronounced => 'y',
},
);

 # Openoffice writer document where we'll manually paste this has 22 cells per page
my $cells = 22;
my $words = $cells*5;
my $letters = 8;

my $cons_count = scalar @consonances;
my $vowel_count = scalar @vowels;


foreach my $w (1..$words) {
	
	my $word_letters = $letters;
	my $variance = int( rand( 2 ) ) - 2;
	$word_letters += $variance;
	
	my $placement;
	my $arabic_word = '';
	foreach my $i ( 1..$word_letters ) {
		
		# odd letters in word are consonances, even are vowels (for simplicity)
		if( $i % 2 == 0 ) {
			my $vow = $vowels[ int( rand( $vowel_count ) ) ];
			print $vow->{pronounced};
		}
		else {
			my $con = $consonances[ int( rand( $cons_count ) ) ];
			print $con->{pronounced};
			my $letter_name = $con->{name};
		}
	}
	print "\n";
}
