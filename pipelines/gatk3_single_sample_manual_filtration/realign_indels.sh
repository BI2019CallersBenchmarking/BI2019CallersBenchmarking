#!/bin/bash

# Indel realignment using GATK

DATENOW=$( date )
echo "Realignment of BAMs started at: $DATENOW"
ENRICHMENT=$1
for DDB in *.dedup.bam
do
    while [ $( ps -u $USER | grep 'java' | wc -l ) -ge 12 ] ; do sleep 1; done
    $JAVA -Xmx8g -jar $GATK -T RealignerTargetCreator -R $REFERENCE -I $DDB \
		-L ${ENRICHMENT} \
		-o ${DDB%%.dedup.bam}.target.intervals &> ../logs/${DDB%%.dedup.bam}.TargetCreator.log &
done
wait

DATENOW=$( date )
echo "Realignment targets created at: $DATENOW"

for DDB in *.dedup.bam
do
    while [ $( ps -u $USER | grep 'java' | wc -l) -ge 12 ] ; do sleep 1; done
    $JAVA -Xmx8g -jar $GATK -T IndelRealigner -R $REFERENCE -I $DDB \
		-L ${ENRICHMENT}  -targetIntervals ${DDB%%.dedup.bam}.target.intervals  \
		-known ${BUNDLE}/Mills_and_1000G_gold_standard.indels.b37.vcf \
		-o ${DDB%%.dedup.bam}.realigned.bam &> ../logs/${DDB%%.dedup.bam}.IndelRealigner.log &
done
wait

mv *.intervals ../logs
mkdir dedupped
mv *.dedup.* dedupped

DATENOW=$( date )
echo "Finished INDEL realigment at: $DATENOW"
