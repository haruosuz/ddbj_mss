# Make Sequence and Annotation Files for DDBJ MSS (Mass Submission System) http://www.ddbj.nig.ac.jp/sub/mss_flow-e.html
# Haruo Suzuki <haruo@g-language.org>
# Last Update: 2015-07-16

# Download Sample annotation file http://www.ddbj.nig.ac.jp/sub/mss/sample-e.html
  wget http://www.ddbj.nig.ac.jp/wp-content/downloads/mss/sample/txt/WGS.txt
  sed -e '39,$d' WGS.txt > mss_annotation_header.txt

  ACCESSION="ARPM03 AWTR02 BAUP01";

# Download Fasta
    EXT=fsa_nt
    for ACC in $ACCESSION; do wget http://www.ncbi.nlm.nih.gov/Traces/wgs/?download=$ACC.1.$EXT.gz; gunzip *.gz; mv index.html?download=$ACC.1.$EXT $ACC.$EXT; done

# Download Genbank
     EXT=gbff
     for ACC in $ACCESSION; do wget http://www.ncbi.nlm.nih.gov/Traces/wgs/?download=$ACC.1.$EXT.gz; gunzip *.gz; mv index.html?download=$ACC.1.$EXT $ACC.$EXT; done

# Convert Fasta to Sequence File # http://www.ddbj.nig.ac.jp/sub/mss/sequence_file-e.html
     for ACC in $ACCESSION; do echo $ACC
     INPUT=$ACC.fsa_nt
     OUTPUT=mss_sequence_$INPUT.txt
     perl -pe 's/>/\/\/\n>/g' $INPUT | sed -e '1,1d' > $OUTPUT
     echo '//' >> $OUTPUT
     done

# Convert Genbank to Annotation File # http://www.ddbj.nig.ac.jp/sub/mss/annotation_file-e.html
     for ACC in $ACCESSION; do echo $ACC
     INPUT=$ACC.gbff
     OUTPUT=mss_annotation_$INPUT.txt
     perl gbk2ddbj.pl $INPUT tmp.txt
     cat mss_annotation_header.txt tmp.txt > $OUTPUT
     done
