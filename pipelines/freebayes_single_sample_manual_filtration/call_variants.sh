#!/bin/bash

# call varinats with Freebayes
DATENOW=$( date )
echo "Started calling varinats with Freebayes at: $DATENOW"

for BAM in *.dedup.bam
do
	while [ $( ps -u $USER | grep 'freebayes' | wc -l ) -ge 24 ]; do sleep 1 ; done

	$FREEBAYES -f $REFERENCE -t $CDS $BAM 2> ../logs/${TAG}.freebayes.log > ../vcfs/${BAM%%.recal.bam}.freebayes.vcf &
	
done
wait

DATENOW=$( date )
echo "Finished calling varinats with Freebayes at: $DATENOW"