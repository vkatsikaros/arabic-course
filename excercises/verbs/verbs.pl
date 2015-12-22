use strict;
use warnings;
use utf8;
binmode(STDOUT, ":utf8");

my @tenses = qw / present past_simple  /;
my @pers = qw / εγώ εσύ αυτός εμείς εσείς αυτοί /;
my @verbs =
(
	{
		present      => [ 'τρώ' ],
		past_simple  => [ 'έφαγ' , 'φάγα' ],
		past_perfect => [ 'έτρωγ', 'τρώγα' ],
		endings      => 1,
	},
	{
		present      => [ 'κατοικ' ],
		past_simple  => [ 'κατοίκησ', 'κατοικήσ' ],
		past_perfect => [ 'κατοικούσ' ],
		endings      => 2,
	},
	{
		present      => [ 'δουλεύ' ],
		past_simple  => [ 'δούλεψ', 'δουλέψ' ],
		past_perfect => [ 'δούλευ', 'δουλεύ' ],
		endings      => 3,
	},
	{
		present      => [ 'πίν' ],
		past_simple  => [ 'ήπι' ],
		past_perfect => [ 'έπιν', 'πίν' ],
		endings      => 3,
	},
	{
		present      => [ 'γράφ' ],
		past_simple  => [ 'έγραψ', 'γράψ' ],
		past_perfect => [ 'έγραφ', 'γράφ' ],
		endings      => 3,
	},
	{
		present      => [ 'αποφοιτ' ],
		past_simple  => [ 'αποφοίτησ', 'αποφοιτήσ' ],
		past_perfect => [ 'αποφοιτούσ' ],
		endings      => 2,
	},
	{
		present      => [ 'διαβάζ' ],
		past_simple  => [ 'διάβασ', 'διαβάσ' ],
		past_perfect => [ 'διάβαζ', 'διαβάζ' ],
		endings      => 3,
	},
	{
		present      => [ 'πηγαίν' ],
		past_simple  => [ 'πήγ'  ],
		past_perfect => [ 'πήγαιν', 'πηγαίν' ],
		endings      => 3,
	},
	{
		present      => [ 'αποκτ' ],
		past_simple  => [ 'απόκτησ', 'αποκτήσ' ],
		past_perfect => [ 'αποκτούσ', ],
		endings      => 2,
	},
	{
		present      => [ 'παρακολουθ' ],
		past_simple  => [ 'παρακολούθησ', 'παρακολουθήσ' ],
		past_perfect => [ 'παρακολούθουσ', 'παρακολουθούσ' ],
		endings      => 2,
	},
	{
		present      => [ 'μιλά' ],
		past_simple  => [ 'μίλησ', 'μιλήσ' ],
		past_perfect => [ 'μιλούσ', ],
		endings      => 1,
	},
);

my %endings = (
	'1' => {
		present      => [ qw/ ω ς  ει με τε νε / ],
		past_simple  => [ qw/ α ες ε  με τε αν / ],
		past_perfect => [ qw/ α ες ε  με τε αν / ],
	},
	'2' => {
		present      => [ qw/ ώ είς εί ούμε είτε ούν /],
		past_simple  => [ qw/ α ες  ε  αμε  ατε  αν /],
		past_perfect => [ qw/ α ες  ε  αμε  ατε  αν /],
	},
	'3' => {
		present      => [ qw/ ω εις  ει ουμε ετε ουν /],
		past_simple  => [ qw/ α ες   ε  αμε  ατε αν /],
		past_perfect => [ qw/ α ες   ε  αμε  ατε αν /],
	},
);

my @sexes = qw/ m f /;

use  Data::Dumper ;
#print Dumper(\%endings);

foreach(1..120)
{
	my $v = int( rand( @verbs ) );
	my $t = @tenses[ int( rand( @tenses ) ) ];
	my $p = int( rand( @pers ) );
	
	my $tense_stem = $verbs[ $v ]->{ $t };
	my $verb_ending = $verbs[ $v ]->{ endings };
	my $ending = $endings{ $verb_ending }->{ $t }[ $p ];
	
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