#!/bin/bash

DATENOW=$( date )
PREFIX=$1
echo "Genotyping GVCFs started at: $DATENOW"

mkdir gvcfs
mv *.g.vcf* gvcfs
ls ${PWD}/gvcfs/*.g.vcf | cat $PADDINGCOHORT - > gvcfs.list

$JAVA -Xmx64g -jar $GATK -T GenotypeGVCFs -R $REFERENCE -V gvcfs.list \
		-o ${PREFIX}.raw.vcf &> ../logs/$1.GenotypeGVCFs.log

DATENOW=$( date )
echo "Genotyping GVCFs finished at: $DATENOW"
