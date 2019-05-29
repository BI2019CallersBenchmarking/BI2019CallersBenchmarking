#!/bin/bash 

# Marking duplicate reads in BAM files
DATENOW=$( date )
echo "Started marking duplicates at: $DATENOW"
mkdir tmp

for BAM in *.bam
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 24 ]; do sleep 1 ; done
	java -Xmx2g -jar $PICARD MarkDuplicates I=$BAM O=${BAM%%.bam}.dedup.bam M=../logs/${BAM%%.bam}.MD.metrics ASSUME_SORTED=true TMP_DIR=${PWD}/tmp &> ../logs/${BAM%%.bam}.MD.log & 
done
wait

rm -rf tmp

DATENOW=$( date )
echo "Finished marking duplicates at: $DATENOW"
