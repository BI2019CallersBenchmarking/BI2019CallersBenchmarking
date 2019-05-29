#!/bin/bash

# Create recalibration reports in BAM files
DATENOW=$( date )
echo "Started making recalibration reports at: $DATENOW"

for BAM in *.dedup.bam
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 24 ]; do sleep 1 ; done
	java -Xmx2g -jar $GATK4 BaseRecalibrator -R $REFERENCE -I $BAM -O ${BAM%%.dedup.bam}.recal_data.table \
	 --known-sites $DBSNP --known-sites $INDELS -L $CDS -use-original-qualities &> ../logs/${BAM%%.dedup.bam}.RDT.log & 
done
wait

DATENOW=$( date )
echo "Finished making recalibration reports at: $DATENOW"