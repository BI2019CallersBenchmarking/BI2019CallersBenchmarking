#!/bin/bash

# Create recalibration reports in BAM files
DATENOW=$( date )
echo "Started calling varinats with HaplotypeCaller at: $DATENOW"

for BAM in *.recal.bam
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 24 ]; do sleep 1 ; done
	java -Xmx2g -jar $GATK4 HaplotypeCaller -R $REFERENCE -I $BAM -O ../vcfs/${BAM%%.recal.bam}.HC.vcf.gz \
	 -L $CDS -bamout ${BAM%%.recal.bam}.bamout.bam &> ../logs/${BAM%%.recal.bam}.HC.log & 
done
wait

DATENOW=$( date )
echo "Finished calling varinats with HaplotypeCaller at: $DATENOW"