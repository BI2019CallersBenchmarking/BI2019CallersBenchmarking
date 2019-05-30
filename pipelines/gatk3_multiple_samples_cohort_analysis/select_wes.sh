#!/bin/bash

DATENOW=$( date )
PREFIX=$1
echo "Selecting relevant samples started at: $DATENOW"

SAMPLEREGEX=$( ls gvcfs/*.g.vcf | grep -oP 'sample_\K[^\.]+' - | sed 's/^/S/' | paste -s -d '|' )

mkdir vqsr

$JAVA -Xmx64g -jar $GATK -T SelectVariants -R $REFERENCE \
	-V ${PREFIX}.recal.vcf \
	-se "$SAMPLEREGEX" \
	-select 'vc.isNotFiltered()' --excludeNonVariants \
	-o ${PREFIX}.retained.vcf &> ../logs/${PREFIX}.SampleSelection.log

mv *.recal* vqsr/
mv *tranches* vqsr/
mv *.plots.* vqsr/
mv *.raw* vqsr/
