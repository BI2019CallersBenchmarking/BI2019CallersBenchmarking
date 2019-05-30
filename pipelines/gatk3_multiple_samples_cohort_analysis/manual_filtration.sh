#!/bin/bash

DATENOW=$( date )
PREFIX=$1
echo "Started filtration at: $DATENOW"

$JAVA -jar $GATK -T SelectVariants -R $REFERENCE \
	-V ${PREFIX}.raw.vcf -o ${PREFIX}.SNP.vcf -selectType SNP -selectType MIXED &> ../logs/${PREFIX}.MF.log

$JAVA -jar $GATK -T SelectVariants -R $REFERENCE \
	-V ${PREFIX}.raw.vcf -o ${PREFIX}.INDEL.vcf -selectType INDEL -selectType MIXED &>> ../logs/${PREFIX}.MF.log

$JAVA -jar $GATK -T VariantFiltration -R $REFERENCE \
	-V ${PREFIX}.SNP.vcf \
	-filter "QD < 2.0 || FS > 60.0 || SOR > 4.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
	-filterName SNP_filter -o ${PREFIX}.F1.vcf &>> ../logs/${PREFIX}.MF.log

$JAVA -jar $GATK -T VariantFiltration -R $REFERENCE \
	-V ${PREFIX}.INDEL.vcf \
	-filter "QD < 2.0 || FS > 200.0 || SOR > 10.0 || InbreedingCoeff < -0.8 || ReadPosRankSum < -12.0" \
	-filterName INDEL_filter -o ${PREFIX}.F2.vcf &>> ../logs/${PREFIX}.MF.log

$JAVA -jar $GATK -T CombineVariants -R $REFERENCE \
	-V:snps ${PREFIX}.F1.vcf -V:indels ${PREFIX}.F2.vcf -o ${PREFIX}.F3.vcf \
	--genotypemergeoption PRIORITIZE --rod_priority_list "snps,indels" &>> ../logs/${PREFIX}.MF.log
 
$JAVA -jar $GATK -T SelectVariants -R $REFERENCE \
	-V ${PREFIX}.F3.vcf -o ${PREFIX}.preretained.vcf \
	-se "vc.IsNotFiltered()" --excludeNonVariants &>> ../logs/${PREFIX}.MF.log

grep -vP '\t[SNPINDEL]+_filter\t' ${PREFIX}.preretained.vcf > ${PREFIX}.retained.vcf

mkdir MF
mv *.F*vcf* MF/
mv *.SNP.vcf* MF/
mv *.INDEL.vcf* MF/
mv *.preretained.vcf* MF/

DATENOW=$( date )
echo "Variant filtration finished at: $DATENOW"
