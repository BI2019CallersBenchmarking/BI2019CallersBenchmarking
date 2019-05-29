#!/bin/bash

DATENOW=$( date )
echo "Alignment started at: $DATENOW"

for FQ in fastqs/*R1.fastq.gz
do
	TMPTAG=${FQ%%.R1.fastq.gz}
	TAG=${TMPTAG##fastqs/}
	SMP=$( echo $TAG | grep -oP 'sample_\K[^\.]+' )
	echo "Aligning $TAG"
	$BWA mem -M -t 16 -R "@RG\tID:$TAG\tSM:${SMP}\tLB:1\tPL:illumina" \
		$REFERENCE ${TMPTAG}.R1.fastq.gz ${TMPTAG}.R2.fastq.gz \
		2> ./logs/${TAG}.bwa.log | $SAMTOOLS view -bS - > ./bams/${TAG}.bam 
done

DATENOW=$( date )
echo "Alignment finished at: $DATENOW"

