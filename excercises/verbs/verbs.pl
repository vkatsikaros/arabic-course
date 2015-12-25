use strict;
use warnings;
use utf8;
binmode(STDOUT, ":utf8");

use Data::Dumper;
use YAML::XS;

my $conf = YAML::XS::LoadFile('verbs.yaml');

my @pers = qw / εγώ εσύ αυτός εμείς εσείς αυτοί /;
my @sexes = qw/ m f /;

my $verbs = $conf->{ verbs };
my $endings = $conf->{ endings };

#print Dumper($verbs);
#print Dumper($endings);

foreach(1..143)
{
	my $i = int( rand( @$verbs ) );
	my $verb = @$verbs[ $i ];
	my $p = int( rand( @pers ) );
	
	# pick one of the verb's available tenses
	my @tenses = grep {
	                 $_ ne 'past_cont'
	             } 
	             keys %{ $verb->{ stem } };
	my $t = $tenses[ int( rand( @tenses ) ) ];

	#print Dumper($verb);
	#print "$t\n";
	
	my $tense_stem = $verb->{ stem }->{ $t };  
	my $verb_ending = $verb->{ ending };
	my $ending = $endings->{ $verb_ending }->{ $t }[ $p ];

	#print "$verb_ending - $ending\n";
	#print Dumper( $endings->{ $verb_ending }->{ $t } );

	my $stem;
	
	# if 2 stems are available: 
	#  2nd is for the 1st/2nd plural (3,4 in array index)
	#  1st is for the rest
	if( scalar @$tense_stem > 1 and ( $p == 3 or $p == 4 ) ){
		$stem = @{$tense_stem}[1];
	}
	else {
		$stem = @{$tense_stem}[0];
	}
	

	my $s = int( rand( @sexes ) );
	my $sex = '';
	if( $p == 1 or $p == 2 ) {
		$sex = $sexes[ $s ];
	}

	#print "$t $p\n";
	print  "${stem}$ending $sex \\\\ \n";
	
}