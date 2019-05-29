#!/bin/bash

CNN_CONFIGATIONS=$1

if [ $CNN_CONFIGATIONS = "CNN_1D" ]
then
	SUFFIX="1d"
elif [ $CNN_CONFIGATIONS = "CNN_2D" ]
then
	SUFFIX="2d"
fi

# filtration
DATENOW=$( date )
echo "Started filtration with $CNN_CONFIGATIONS at: $DATENOW"

for vcf in *".HC.cnn_$SUFFIX_annotated.vcf.gz"
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 24 ]; do sleep 1 ; done

	java -Xmx2g -jar $GATK4 FilterVariantTranches -V $vcf --output ${vcf%%".HC.cnn_$SUFFIX_annotated.vcf.gz"}.HC.cnn_$SUFFIX_filtered.vcf.gz \
	-resource $HAPMAP -resource $THG -resource $INDELS -info-key $CNN_CONFIGATIONS --snp-tranche $SNP_TRANCHE --indel-tranche $INDEL_TRANCHE \
	 &> ../logs/${vcf%%.vcf.gz}.cnn$SUFFIX_filtration.log &

done
wait

DATENOW=$( date )
echo "Finished filtration with $CNN_CONFIGATIONS at: $DATENOW"