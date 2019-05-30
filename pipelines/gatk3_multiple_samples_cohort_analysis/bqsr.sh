#1/bin/bash

DATENOW=$( date )
echo "Started BQSR at: $DATENOW"
ENRICHMENT=$1

for BAM in *.realigned.bam
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 12 ]; do sleep 1; done
	$JAVA -Xmx6g -jar $GATK -T BaseRecalibrator -R $REFERENCE -I $BAM \
		-knownSites ${BUNDLE}/dbsnp_138.b37.vcf \
		-knownSites ${BUNDLE}/Mills_and_1000G_gold_standard.indels.b37.vcf \
		-L ${ENRICHMENT} \
		-o ${BAM%%.realigned.bam}.recal.table 2> ../logs/${BAM%%.realigned.bam}.BaseRecalibrator.log &
done
wait

DATENOW=$( date )
echo "Recalibration tables made at: $DATENOW"

for BAM in *.realigned.bam
do
	while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 12 ]; do sleep 1; done
	$JAVA -Xmx6g -jar $GATK -T PrintReads -R $REFERENCE -I $BAM \
		-BQSR ${BAM%%.realigned.bam}.recal.table \
		-o ${BAM%%.realigned.bam}.recal.bam 2> ../logs/${BAM%%.realigned.bam}.PrintReads.log &
done
wait

mkdir realigned

mv *.realigned.* realigned/
mv *.recal.table ../logs/

DATENOW=$( date )
echo "Recalibration of base qualities finished at: $DATENOW"
