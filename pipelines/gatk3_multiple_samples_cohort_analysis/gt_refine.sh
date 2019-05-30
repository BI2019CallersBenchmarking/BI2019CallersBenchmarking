#!/bin/bash

DATENOW=$( date )
PREFIX=$1
echo "Genotype refinement procedure started at: $DATENOW"

$JAVA -Xmx64g -jar $GATK -T CalculateGenotypePosteriors -R $REFERENCE -V ${PREFIX}.retained.vcf \
	--supporting ${BUNDLE}/1000G_phase3_v4_20130502.sites.vcf -o ${PREFIX}.GR.vcf &> ../logs/${PREFIX}.GenotypeRefinement.log

$JAVA -Xmx64g -jar $GATK -T VariantFiltration -R $REFERENCE -V ${PREFIX}.GR.vcf -G_filter "GQ < 20.0" -G_filterName lowGQ -o ${PREFIX}.GF.vcf &>> ../logs/${PREFIX}.GenotypeRefinement.log

mkdir gt_refine
mv *.retained.* gt_refine/
mv *.GR.* gt_refine/

DATENOW=$( date )
echo "Genotype refinement finished at: $DATENOW"
