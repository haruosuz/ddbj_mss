# [Make Sequence and Annotation Files for DDBJ MSS (Mass Submission System)](http://www.ddbj.nig.ac.jp/sub/mss_flow-e.html)
## Haruo Suzuki (haruo[at]g-language[dot]org)  
## Last Update: 2015-07-16

# Usage
* perl gbk2ddbj.pl <INPUT_Genbank.gbk> <OUTPUT_DDBJ_MSS.txt>

# Sample WGS data files
* [Holospora undulata HU1](http://www.ncbi.nlm.nih.gov/Traces/wgs/?val=ARPM03)
* [Holospora obtusa F1](http://www.ncbi.nlm.nih.gov/Traces/wgs/?val=AWTR02)
* [Holospora elegans E1](http://www.ncbi.nlm.nih.gov/Traces/wgs/?val=BAUP01)

# Make Sequence Files for DDBJ MSS
    ACCESSION="ARPM03 AWTR02 BAUP01";
    FASTA=fsa_nt

## Download sample Fasta files from NCBI
    for ACC in $ACCESSION; do 
    wget http://www.ncbi.nlm.nih.gov/Traces/wgs/?download=$ACC.1.$FASTA.gz;
    gunzip *.gz; mv index.html?download=$ACC.1.$FASTA $ACC.$FASTA; done

## [Convert Fasta to Sequence Files for DDBJ MSS](http://www.ddbj.nig.ac.jp/sub/mss/sequence_file-e.html)
    for ACC in $ACCESSION; do echo $ACC
    INPUT=$ACC.$FASTA
    OUTPUT=mss_sequence_$INPUT.txt
    perl -pe 's/>/\/\/\n>/g' $INPUT | sed -e '1,1d' > $OUTPUT
    echo '//' >> $OUTPUT
    done

# Make Annotation Files for DDBJ MSS
    ACCESSION="ARPM03 AWTR02 BAUP01";
    GBK=gbff

## Download sample Genbank files from NCBI
    for ACC in $ACCESSION; do 
    wget http://www.ncbi.nlm.nih.gov/Traces/wgs/?download=$ACC.1.$GBK.gz; 
    gunzip *.gz; mv index.html?download=$ACC.1.$GBK $ACC.$GBK; done

## [Download Sample annotation files from DDBJ](http://www.ddbj.nig.ac.jp/sub/mss/sample-e.html)
    wget http://www.ddbj.nig.ac.jp/wp-content/downloads/mss/sample/txt/WGS.txt
    sed -e '39,$d' WGS.txt > mss_annotation_header.txt

## [Convert Genbank to Annotation Files for DDBJ MSS](http://www.ddbj.nig.ac.jp/sub/mss/annotation_file-e.html)
    for ACC in $ACCESSION; do echo $ACC
    INPUT=$ACC.$GBK
    OUTPUT=mss_annotation_$INPUT.txt
    perl gbk2ddbj.pl $INPUT tmp.txt
    cat mss_annotation_header.txt tmp.txt > $OUTPUT
    done

# ToDoList
* Convert MCL output to gene content table

