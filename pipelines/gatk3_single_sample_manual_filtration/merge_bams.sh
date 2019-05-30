#!/bin/bash

DATENOW=$( date )
echo "Merging BAMs started at: $DATENOW"

ls *.bam | grep -oP '.*sample_[^\.]+' | sort -u > samples.list

if [ $( cat samples.list | wc -l ) == $( ls *.bam | wc -l ) ]
then
	echo "Single-lane experiment? Skipping merge step" # это мой случай??
	for i in *.bam
	do
		mv $i ${i%%.lane*}.bam #отрезаем инфу о дорожке, потому что она лишняя
	done
else
	for i in $( cat samples.list )
	do
		while [ $( ps -u $USER | grep 'samtools' | wc -l ) -ge 24 ] ; do sleep 1 ; done
		$SAMTOOLS merge ${i}.bam ${i}.* & # что вот это *& значит? Типа у нас в инпуте все файлы, которые начинаются с ${i}?
	done
	wait
	rm *.lane_*
fi

DATENOW=$( date )
echo "Merging BAMs finished at: $DATENOW"
