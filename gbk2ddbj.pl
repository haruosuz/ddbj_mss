# can't recognize > e.g. complement(6026..>6118)
use strict;
my $regexp = 'ComE operon|ComEC|CysZ-like|DnaJ-like|EamA-like|Fe[^a-z]|Na\(\+\)\/H\(\+\) antiporter|Holliday junction|Hom_end-associated Hint|Kelch-like|LexA repressor|Lon protease|LysM|Maf-like|MgtE |NifU-like|OsmC-like|ParA-like|Phd.YefM|PhoD-like|PhoH-like|RlpA-like|SCO2-like|SmpA |Trk system|Trp|TspO/MBR family|Williams-Beuren syndrome|Xaa-Pro|YqaJ-like|Zinc-type|Zn-|Zn-ribbon-containing'; #print "regexp: $regexp\n\n";
my ($locus, $pos, $ntype, $gene); my $n_lcfirst = 0; my $randn = rand(1);
my $file = $ARGV[0];
open(OUT, ">$ARGV[1]");
open(FILE, $file)||die"cannot open file : $! \n";
while(<FILE>){
    if($_ =~ /^LOCUS \s+(\S+)/){ $locus = $1; }
    if($_ =~ /^     source/){
	my %hash;
	if($_ =~ / +(\d+\.\.\d+)/){ $pos = $1; }
	while(<FILE>){
	    if($_ =~ /\/(organism|mol_type)=\"([^\"]+)\"/){ $hash{$1} = $2; }
	    elsif($_ =~ /\/(strain)=\"([^\"]+)\"/){ 
		$hash{$1} = $2;
		print OUT "$locus\tsource\t$pos\torganism\t$hash{organism}\n";
		foreach(sort keys %hash){ next if(/organism/); print OUT "\t\t\t$_\t$hash{$_}\n"; }
		print OUT "\t\t\tff_definition\t@@[organism]@@ DNA, contig: @@[entry]@@\n";
		print OUT "\t\t\tnote\tcontig: @@[entry]@@\n";
		last; 
	    }
	}
    }
    if($_ =~ /^     (CDS|rRNA|tRNA|tmRNA|sig_peptide)/){
	my %hash;
	my $type = $1; $ntype ++;
	if($_ =~ / +(complement\(\d+\.\.\d+\))/ || / +(\d+\.\.\d+)/){ $pos = $1; }
	while(<FILE>){
	    if($_ =~ /\/(codon_start|transl_table|tag_peptide)=(.+)/){ $hash{$1} = $2; }
	    elsif($_ =~ /\/(locus_tag|inference|product|note|gene)=\"([^\"]+)/){
		my $key = $1; my $value = $2; chomp $value;
		while($_ !~ /\"$/){ $_ = <FILE>; chomp; my $tmp = $_; $tmp =~ s/\"//; $tmp =~ s/\s+/ /; $value .= $tmp; }
		if($key eq 'product' && $value =~ /^[A-Z][a-z]/ && $value !~ /^($regexp)/){ $n_lcfirst ++; $value = lcfirst($value); }
		$value =~ s/COORDINATES://; # /inference="COORDINATES: profile:Aragorn:1.2"
		$value =~ s/:Pfam:/:PFAM:/; # /inference="protein motif:Pfam:PF02687.15"
		if(defined $hash{$key}){ $randn = rand(1); $hash{$key.$randn} = $value; } else { $hash{$key} = $value; } # /inference x 2 # /inference="ab initio prediction:Prodigal:2.60" # /inference="similar to AA sequence:
	    }
	    if( ($type eq 'CDS' && $_ =~ /\/translation=/) || ($type =~ /rRNA|tmRNA/ && $_ =~ /\/inference=/) || ($type =~ /tRNA|sig_peptide/ && $_ =~ /\/note=/) ){
		if($type eq 'CDS'){
		    undef $gene;
		    # /gene= GN= # /product="Cytochrome c OS=Pongo abelii GN=CYCS
		    if(defined $hash{gene}){ $gene = $hash{gene}; }
		    elsif($hash{product} =~ /GN=([^_]+) PE=/ && $1 !~ /^[\.0-9]+$|^[A-Z]\S*[0-9]{3,}|sll|slr|SPBC|SPAC/){ $hash{gene} = $gene = $1; }
		    # remove possible locus tags
		    if($hash{product} =~ /(.+) ([A-Z]\S*[0-9]{3,}|(sll|slr)[0-9]+) OS=.+/){ $hash{product} = $1; }
		    $hash{product} =~ s/( OS=.+)$// if(defined $hash{product});
		    $hash{note} =~ s/( OS=.+)$// if(defined $hash{note});
		    if($hash{product} =~ /^protein$/){ $hash{product} = "hypothetical protein"; } # "Protein DVU_0535 OS=

		    # move to /note=
		    if($hash{product} =~ /(.+ (regulator|protein)) (containing .+)/){ $hash{product} = $1; $hash{note} = $3; }
		    if($hash{product} =~ /(.+) [\(\[](.+)[\)\]]$/){ $hash{product} = $1; $hash{note} = $2; } # /product="DNA primase (bacterial type)" # /product="Superoxide dismutase [Fe] OS=Leptolyngbya

		    # rename to "putative protein"
		    if($hash{product} =~ /rotein involved in (.+)/){ $hash{note} = $1; $hash{product} = "putative protein"; }
		    if($hash{product} =~ /putative protein/ && $hash{product} !~ /protein( in | kinase|-disulfide oxidoreductase)/){ $hash{product} = "putative protein"; }
		     
		    if($hash{product} =~ /(motif|repeat)$/){ $hash{product} .= " protein"; }
		    #if(length($hash{product}) < 5){ print "$hash{locus_tag}: $hash{product}\n"; $hash{product} .= " protein"; } # fixH doxX nosL
		    #
		    $hash{product} =~ s/Phd_YefM/antitoxin Phd_YefM, type II toxin-antitoxin system/;
		    $hash{product} =~ s/\(GNAT\)/GNAT/;
		    $hash{product} =~ s/5- /5-/;
		    $hash{product} = lc $hash{product} if($hash{product} =~ /TRIGALACTOSYLDIACYLGLYCEROL/);
		    #$hash{product} =~ s/geobacter //; # check contami		    
		}
		elsif($type eq 'sig_peptide' && !(defined $hash{gene}) && defined $gene){ $hash{gene} = $gene; }
		#elsif($type eq 'tRNA' && $hash{note} =~ /tmRNA\*([A-Z]+)\*/){ $hash{note} = "tag peptide: $1"; $hash{product} = $type = "tmRNA"; } # /note="tmRNA*ANDNEAFAVAA*"
		#elsif($type eq 'tRNA' && $hash{note} =~ /tRNA-Ser\(cag\)/){ $hash{note} = "tRNA-Leu(cag)"; $hash{product} = "tRNA-Leu"; }
# tRNA-Leu(cag) if "aragorn -gc1"  The Standard Code
# tRNA-Ser(cag) if "aragorn -gc11" The Bacterial, Archaeal and Plant Plastid Code
		print OUT "\t$type\t$pos"; my $cnt = 0; foreach my $key (sort keys %hash){ @_ = split(/$randn/, $key); print OUT "\t\t" if($cnt); print OUT "\t$_[0]\t$hash{$key}\n"; $cnt ++; }
		last;
	    }
	}
    }
}
close FILE;
close OUT;
#print "-----------------\n";
#print "No.type (CDS|rRNA|tRNA|sig_peptide) = $ntype\n";
#print "No.lcfirst = $n_lcfirst\n";
__END__
grep "gene[[:space:]][A-Z].*[0-9]\{3,\}" output.txt
# locus_tag
sll0108 # Synechocystis sp. (strain PCC 6803 / Kazusa)
slr0516 # Synechocystis sp. (strain PCC 6803 / Kazusa) 
SPBC2A9.02 # Schizosaccharomyces pombe (strain 972 / ATCC 24843) (Fission yeast)
SPAC14C4.10c # Schizosaccharomyces pombe (strain 972 / ATCC 24843) (Fission yeast)

## grep -r "uniprot_sprot.fasta:sp|" $OFILE
perl -i -pe 's/uniprot_sprot.fasta:sp\|(.+)\|(.+)/UniProtKB:$1/g' $OFILE
## grep -r "similar to AA sequence" $OFILE
