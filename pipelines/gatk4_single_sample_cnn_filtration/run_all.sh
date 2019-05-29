#!/bin/bash

CNN_CONFIGATIONS=$1

case "$CNN_CONFIGATIONS" in
  "CNN_1D")
	DATENOW=$( date )
	echo "Script started with $CNN_CONFIGATIONS param at: $DATENOW"
    ;;
  "CNN_2D")
	DATENOW=$( date )
	echo "Script started with $CNN_CONFIGATIONS param at: $DATENOW"
    ;;
  *)
    echo "Unsupported cnn configuration. Avaialbe values are {CNN_1D,CNN_2D}"
    exit 1
    ;;
esac

#get path to executables and other variables
source ./configure.cfg

cd fastqs

#organize files and dirs
bash ./organize_files.sh

cd ..

#run bwa-mem
bash ./run_bwamem.sh

cd bams/

#sort bams
bash ../sort_bams.sh

#merge read group / lanes bams to one
bash ../merge_bams.sh

#mark dublicates with picard
bash ../mark_dups.sh

#clear temp data
mkdir tmp
mv *.dedup.bam tmp/
rm *.bam
mv tmp/* .
rm -rf tmp

#index bams
bash ../index_bams.sh

#create recal reports
bash ../create_recalibration_reports.sh

#make single sample vcf
bash ../call_variants.sh

cd ..
cd vcfs

if [ $CNN_CONFIGATIONS = "CNN_1D" ]
then
	#annotate vcf with 1d cnn
	bash  ../cnn1d_annotation.sh	
elif [ $CNN_CONFIGATIONS = "CNN_2D" ]
then
	#annotate vcf with 2d cnn
	bash  ../cnn2d_annotation.sh
fi

#filtration
bash ../filter_vcf.sh $CNN_CONFIGATIONS