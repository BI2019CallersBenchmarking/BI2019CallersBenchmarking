#!/bin/bash

# filtration
DATENOW=$( date )
echo "Started filtration at: $DATENOW"

for vcf in *.freebayes.vcf
do
	while [ $( ps -u $USER | grep 'bcftools' | wc -l ) -ge 24 ]; do sleep 1 ; done

    $BCFTOOLS filter $vcf -e 'QUAL<$QUAL' -s LowQual -o ${vcf%%.freebayes.vcf}.freebayes.filtered.vcf \
     &> ../logs/${vcf%%.freebayes.vcf}.freebayes.filter.log & 

done
wait

DATENOW=$( date )
echo "Finished filtration at: $DATENOW"