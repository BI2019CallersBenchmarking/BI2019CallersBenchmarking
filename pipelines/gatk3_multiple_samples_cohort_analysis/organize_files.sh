#!/bin/bash

mkdir fastqs bams vcfs hs_metrics logs
mv *.gz fastqs

cd fastqs

for FQ in *.fastq.gz
do
    echo $FQ > name
    mv $FQ $1.sample_${FQ%%_*}.lane_$( grep -oP 'L00\K\d' name ).R$( grep -oP '_R\K\d' name ).fastq.gz
    rm name
done

cd ../
