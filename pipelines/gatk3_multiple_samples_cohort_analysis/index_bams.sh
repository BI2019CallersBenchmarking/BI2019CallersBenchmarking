#!/bin/bash

DATENOW=$( date )
echo "Started indexing BAMs at: $DATENOW"

for i in *.bam
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 24 ]; do sleep 1 ; done
	$SAMTOOLS index $i &
done
wait

DATENOW=$( date )
echo "Indexing BAMs finished at: $DATENOW"
