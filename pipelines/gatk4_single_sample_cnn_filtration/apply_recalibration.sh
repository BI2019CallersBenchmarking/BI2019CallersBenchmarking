#!/bin/bash

# Apply recalibration
DATENOW=$( date )
echo "Started apply recalibration at: $DATENOW"

for recal_table in *.recal_data.table
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 24 ]; do sleep 1 ; done
	java -Xmx2g -jar $GATK4 ApplyBQSR -R $REFERENCE -I ${recal_table%%.recal_data.table}.dedup.bam \
    -O ${recal_table%%.recal_data.table}.recal.bam -bqsr $recal_table -L $CDS --static-quantized-quals 10 \
	--static-quantized-quals 20 --static-quantized-quals 30 --add-output-sam-program-record \
	--use-original-qualities &> ../logs/${recal_table%%.recal_data.table}.AR.log & 
done
wait

DATENOW=$( date )
echo "Finished apply recalibration at: $DATENOW"
