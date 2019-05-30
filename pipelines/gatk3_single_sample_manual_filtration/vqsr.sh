#!/bin/bash

DATENOW=$( date )
PREFIX=$1
echo "Filtering VCFs started at: $DATENOW"

echo "Modelling SNPs"
$JAVA -Xmx64g -jar $GATK -T VariantRecalibrator \
        -R $REFERENCE \
        -input ${PREFIX}.raw.vcf \
        -resource:hapmap,known=false,training=true,truth=true,prior=15.0 ${BUNDLE}/hapmap_3.3.b37.vcf \
        -resource:omni,known=false,training=true,truth=true,prior=12.0 ${BUNDLE}/1000G_omni2.5.b37.vcf \
        -resource:mills,known=false,training=true,truth=true,prior=12.0 ${BUNDLE}/Mills_and_1000G_gold_standard.indels.b37.vcf \
        -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${BUNDLE}/dbsnp_138.b37.vcf \
        -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
        -mode SNP \
        -recalFile ${PREFIX}.snp.recal \
        -tranchesFile ${PREFIX}.snp.tranches \
        -rscriptFile ${PREFIX}.snp.plots.R &> ../logs/${PREFIX}.SNP.VariantRecalibrator.log

echo "Applying SNP filter"
$JAVA -Xmx64g -jar $GATK -T ApplyRecalibration \
        -R $REFERENCE \
        -input ${PREFIX}.raw.vcf \
        -mode SNP \
        -recalFile ${PREFIX}.snp.recal \
        -tranchesFile ${PREFIX}.snp.tranches \
        -o ${PREFIX}.snp.recal.vcf \
        -ts_filter_level $SNPVQSLOD &> ../logs/${PREFIX}.SNP.ApplyRecalibration.log

echo "Modelling INDELs"
$JAVA -Xmx64g -jar $GATK -T VariantRecalibrator \
        -R $REFERENCE \
        -input ${PREFIX}.snp.recal.vcf \
        --maxGaussians 4 \
        -resource:mills,known=false,training=true,truth=true,prior=12.0 ${BUNDLE}/Mills_and_1000G_gold_standard.indels.b37.vcf \
        -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${BUNDLE}/dbsnp_138.b37.vcf \
        -an QD -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
        -mode INDEL \
        -recalFile ${PREFIX}.indel.recal \
        -tranchesFile ${PREFIX}.indel.tranches \
        -rscriptFile ${PREFIX}.indel.plots.R &> ../logs/${PREFIX}.INDEL.VariantRecalibrator.log

echo "Applying INDEL filter"
$JAVA -Xmx64g -jar $GATK -T ApplyRecalibration \
        -R $REFERENCE \
        -input ${PREFIX}.snp.recal.vcf \
        -mode INDEL \
        -recalFile ${PREFIX}.indel.recal \
        -tranchesFile ${PREFIX}.indel.tranches \
        -o ${PREFIX}.recal.vcf \
        -ts_filter_level $INDELVQSLOD &> ../logs/${PREFIX}.INDEL.ApplyRecalibration.log

DATENOW=$( date )
echo "VQSR procedures finished at: $DATENOW"
