#!/bin/perl
use strict;
use warnings;
#usage: perl mapsigmodels.pl [sighits file] [input directory containing subsampled fastas] [output directory to hold sigmodel files (inputs to predicttrophicmode)]

my $sighits=shift;
my $indir=shift;
my $outdir=shift;
my $species=$sighits; ###variable to get species name
$species =~ s{^.*/|\.[^.]+$}{}g; ###remove file handle stuff

my %maph;
my @outmod;

###extract species name from sighits filename
###example sig hits file: Capsaspora_owczarzaki_sigHits.txt
my @specarr=split(/_/,$species);
#genus may be enough to find subsamples later. If not can use genus and species using commented join function.
my $spec=$specarr[0];#join("_",$specarr[0],$specarr[1]); 
################################

###map all sighit hmms to each gene from a species. The sighit hmms will serve as sigmodels input for predicting trophic mode.
open(IN0, "<", $sighits) or die "could not open IN $sighits\n";
while(<IN0>){
	chomp($_);
	my @line=split(/\t|\s+/,$_);
	push(@{$maph{$line[0]}},$line[2]);
	#print "SIGLINE:\t$line[0]\t$line[2]\tDONE\n";
}
close(IN0);
##########################


####process subsampled files from one species (defined from sig hits file) to obtain all sigmodels present in each subsampled protein file (using a map rather than having to run hmmsearch on every subsampled protein file).
###example subsampled file: 0.70.5.cleanEP00120_Capsaspora_owczarzaki.fasta
my @files = glob("$indir/*.*");
foreach my $file (@files){
@outmod=();
if($file =~ /$spec/){ ###here checks whether subsampled file is from sighits species.
my $outspec=join("",$spec,"_sigmodelsDIR");
open(IN,"<", $file) or die "could not open IN $file\n";
$file =~ s{^.*/|\.[^.]+$}{}g;
my $outfile = join("",$file,"_sigModels.txt");
print "$outfile\n";
`mkdir -p $outdir/$outspec`;
open(OUT,">","$outdir/$outspec/$outfile") or die "could not open OUT $outfile\n";
while(<IN>){
	chomp($_);
	if($_ =~ /^>/){
		$_ =~ s/>//;
		if(exists $maph{$_}){
			push(@outmod,@{$maph{$_}});
		}
	}
}
#print "@outmod\n";
my @uniqoutmod = uniq(@outmod);
foreach my $mod (@uniqoutmod){
#print "$mod\n";
print OUT "$mod\n"; ###outputs sigmodels for the fasta subsample
}
#print "$file\n";
close(IN);
close(OUT);
}
}


sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
