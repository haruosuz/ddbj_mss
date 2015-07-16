# [Make Sequence and Annotation Files for DDBJ MSS (Mass Submission System)](http://www.ddbj.nig.ac.jp/sub/mss_flow-e.html)
* Haruo Suzuki <haruo@g-language.org>
* Last Update: 2015-07-16

## Usage
    perl gbk2ddbj.pl <INPUT_Genbank.gbk> <OUTPUT_DDBJ_MSS.txt>

# Sample WGS data files
* [Holospora undulata HU1](http://www.ncbi.nlm.nih.gov/Traces/wgs/?val=ARPM03)
* [Holospora obtusa F1](http://www.ncbi.nlm.nih.gov/Traces/wgs/?val=AWTR02)
* [Holospora elegans E1](http://www.ncbi.nlm.nih.gov/Traces/wgs/?val=BAUP01)

# Make Sequence Files for DDBJ MSS
## Download sample Fasta files from NCBI
    echo 'Download sample Fasta files from NCBI'; EXT=fsa_nt
    ACCESSION="ARPM03 AWTR02 BAUP01";
    for ACC in $ACCESSION; do 
    wget http://www.ncbi.nlm.nih.gov/Traces/wgs/?download=$ACC.1.$EXT.gz;
    gunzip *.gz; mv index.html?download=$ACC.1.$EXT $ACC.$EXT; done

## [Convert Fasta to Sequence Files for DDBJ MSS](http://www.ddbj.nig.ac.jp/sub/mss/sequence_file-e.html)
    echo 'Convert Fasta to Sequence File for DDBJ MSS'
    ACCESSION="ARPM03 AWTR02 BAUP01";
    for ACC in $ACCESSION; do echo $ACC
    INPUT=$ACC.fsa_nt
    OUTPUT=mss_sequence_$INPUT.txt
    perl -pe 's/>/\/\/\n>/g' $INPUT | sed -e '1,1d' > $OUTPUT
    echo '//' >> $OUTPUT
    done

# Make Annotation Files for DDBJ MSS
## Download sample Genbank files from NCBI
    echo 'Download sample Genbank files from NCBI'; EXT=gbff
    ACCESSION="ARPM03 AWTR02 BAUP01";
    for ACC in $ACCESSION; do wget http://www.ncbi.nlm.nih.gov/Traces/wgs/?download=$ACC.1.$EXT.gz; 
    gunzip *.gz; mv index.html?download=$ACC.1.$EXT $ACC.$EXT; done

## [Download Sample annotation files from DDBJ](http://www.ddbj.nig.ac.jp/sub/mss/sample-e.html)
    echo 'Download Sample annotation file from DDBJ'
    wget http://www.ddbj.nig.ac.jp/wp-content/downloads/mss/sample/txt/WGS.txt
    sed -e '39,$d' WGS.txt > mss_annotation_header.txt

## [Convert Genbank to Annotation Files for DDBJ MSS](http://www.ddbj.nig.ac.jp/sub/mss/annotation_file-e.html)
    echo 'Convert Genbank to Annotation File for DDBJ MSS'
    for ACC in $ACCESSION; do echo $ACC
    INPUT=$ACC.gbff
    OUTPUT=mss_annotation_$INPUT.txt
    perl gbk2ddbj.pl $INPUT tmp.txt
    cat mss_annotation_header.txt tmp.txt > $OUTPUT
    done

## ToDoList
* Convert MCL output to gene content table
* 
