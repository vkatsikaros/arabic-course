#!/usr/bin/env perl

use strict;
use warnings;

use Encode;
binmode(STDOUT, ":encoding(UTF-8)");

use charnames ":full";
use feature "unicode_strings";

open( my $fh_in,  "<:encoding(UTF-8)", 'my_vocabulary.tex') or die $_;
open( my $fh_out, ">:encoding(UTF-8)", 'my_vocabulary_no_diacritics.tex') or die $_;

my $in_table = 0;
my $start_table = 0;
my $normpl = 0;
my $mfnormpl = 0;
my $pages = 2;

while (my $line = <$fh_in>) {
	# change line spacing
	if( $line =~ s/(\\begin\{document\})/ \\renewcommand{\\baselinestretch}{2} $1/){
		print $fh_out $line;
		next;
	}

	if( $line =~ m/^\%page/) {
		print $fh_out "}\n\n$pages\n\n\\textarabic{";
		$pages++;
		next;
	}

	# remove arabic diacritics and comma
	$line =~ s/(
		\N{ARABIC COMMA} |
		\N{ARABIC DAMMA} |
		\N{ARABIC KASRA} |
		\N{ARABIC FATHA}
		)//gx;

	# remove table begin/end
	if( $line =~ s/\\begin\{supertabular\}\{ c c \}//g ) {
		$in_table = 1;
		$start_table = 1;
	}
	if( $line =~ s/\\end\{supertabular\}//g ) {
		print $fh_out "}"; # close: \textarabic{
		$in_table = 0;
	}

	# in table remove greek and any table latex formatting
	if( $in_table ) {
		# remove everything up to \ar{
		$line =~ s/^.*\\ar\{//g;
		# some lines do not have \ar{ but \normpl{ . Remove that too
		if( $line =~ s/^.*\\normpl\{// ) {
			$normpl = 1;
		}
		if( $line =~ s/^.*\\mfnormpl\{// ) {
			$mfnormpl = 1;
		}
		# remove closing }
		$line =~ s/}//;
		# remove the table new row and eveything till the end of line
		$line =~ s/\\\\.*$//g;

		# if normal plural, print singular and the plural (whole words)
		if( $normpl ) {
			chomp $line ;
			$line =~ s/\s*$//;
			my $word = $line;

			my $plural = $word;
			$plural =~ s/\N{ARABIC LETTER TEH MARBUTA}$//;
			$plural .= "\N{ARABIC LETTER ALEF}\N{ARABIC LETTER TEH} \n";

			$line .= "$word $plural";
			$normpl = 0;
		}

		if( $mfnormpl ) {
			chomp $line ;
			$line =~ s/\s*$//;
			my $word = $line;

			my $plural_stem = $word;
			$plural_stem =~ s/\N{ARABIC LETTER TEH MARBUTA}$//;
			my $masc = $plural_stem . "\N{ARABIC LETTER WAW}\N{ARABIC LETTER NOON} ";
			my $fem = $plural_stem . "\N{ARABIC LETTER YEH}\N{ARABIC LETTER NOON} ";

			$line = "$word $masc $fem ";
			$mfnormpl = 0;
		}
	}

	# start and all encompasing textarabic
	# it ends when the table (in the original) ends too
	if( $start_table ) {
		$start_table = 0;
		$line = '\textarabic{' . $line;
	}

	# skip empty lines
	if( $line =~ m/^\s*$/) {
		next;
	}
	# skip only comment lines
	if( $line =~ m/^%/) {
		next;
	}
	print $fh_out "$line";
}

close $fh_in;
close $fh_out;

exit 0;
