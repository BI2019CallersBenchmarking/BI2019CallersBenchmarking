#!/bin/bash

# annotate vcf with 1d cnn
DATENOW=$( date )
echo "Started annotate vith 1D CNN at: $DATENOW"

for vcf in *.HC.vcf.gz
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 24 ]; do sleep 1 ; done
	java -Xmx2g -jar $GATK4 CNNScoreVariants -R $REFERENCE -V $vcf -O ${vcf%%.HC.vcf.gz}.HC.cnn_1d_annotated.vcf.gz \
	 -L $CDS --tensor-type reference &> ../logs/${vcf%%.vcf.gz}.cnn1d.log & 
done
wait

DATENOW=$( date )
echo "Finished annotate vith 1D CNN at: $DATENOW"