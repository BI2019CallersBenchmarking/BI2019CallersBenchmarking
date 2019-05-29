#!/bin/bash

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

#call variants with freebayes
bash ../call_variants.sh

cd ..
cd vcfs

#Freebayes has no filters, but we can introduce a filter at QUAL=20 using bcftools
#filter variants with estimated probability of not being polymorphic less than phred 20 (aka 0.01)
bash ../filter_vcf.sh
