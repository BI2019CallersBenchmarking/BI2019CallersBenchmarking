#!/bin/bash

# Running GATK HaplotypeCaller in GVCF mode for a directory of BAMs

DATENOW=$( date )
ENRICHMENT=$1
echo "Calling started at: $DATENOW"


for RCB in *.recal.bam
do
    while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 12 ]; do sleep 1; done
    $JAVA -Xmx6g -jar $GATK -T HaplotypeCaller -R $REFERENCE \
		-L $ENRICHMENT -I $RCB -o ../vcfs/${RCB%%.recal.bam}.g.vcf \
		-ERC GVCF &> ../logs/${RCB%%.recal.bam}.HaplotypeCaller.log &
done
wait

DATENOW=$( date )
echo "Calling finished at: $DATENOW"
