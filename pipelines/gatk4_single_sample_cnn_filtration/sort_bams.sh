#!/bin/bash

DATENOW=$( date )
echo "Sorting BAMs started at: $DATENOW"

for i in *.bam
do
	while [ $( ps -u $USER | grep 'samtools' | wc -l ) -ge 24 ] ; do sleep 1 ; done
	TAG=${i%%.bam}
	$SAMTOOLS sort -T ${TAG}.sorted -o ${TAG}.sorted.bam $i & 
done
wait

for i in *.sorted.bam
do
        mv $i ${i%%.sorted.bam}.bam
done

DATENOW=$( date )
echo "Sorting BAMs finished at: $DATENOW"
