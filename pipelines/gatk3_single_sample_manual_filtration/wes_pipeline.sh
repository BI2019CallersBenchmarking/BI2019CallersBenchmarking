#!/bin/bash

source ~/configure.cfg
SCRIPTDIR=~/SCRIPTS
PREFIX=$1
SCRIPTLOG=~/$PREFIX/log



bash ${SCRIPTDIR}/organize_files.sh $PREFIX &>> $SCRIPTLOG
bash ${SCRIPTDIR}/run_bwamem.sh &>> $SCRIPTLOG

cd ./bams/

bash ${SCRIPTDIR}/sort_bams.sh &>> $SCRIPTLOG
bash ${SCRIPTDIR}/merge_bams.sh &>> $SCRIPTLOG
bash ${SCRIPTDIR}/mark_dups.sh &>> $SCRIPTLOG

# Clean-up
mkdir tmp
mv *.dedup.bam tmp/
rm *.bam
mv tmp/* .
rm -rf tmp

bash ${SCRIPTDIR}/index_bams.sh &>> $SCRIPTLOG
bash ${SCRIPTDIR}/realign_indels.sh ${ENRICHMENT} &>> $SCRIPTLOG
bash ${SCRIPTDIR}/bqsr.sh ${ENRICHMENT} &>> $SCRIPTLOG
bash ${SCRIPTDIR}/run_gatkhc.sh ${ENRICHMENT} &>> $SCRIPTLOG

cd ../vcfs/

if $COHORT
then
	bash ${SCRIPTDIR}/genotype_wes.sh $PREFIX &>> $SCRIPTLOG
	bash ${SCRIPTDIR}/vqsr.sh $PREFIX &>> $SCRIPTLOG
else
	bash ${SCRIPTDIR}/genotype_nonwes.sh $PREFIX &>> $SCRIPTLOG
	bash ${SCRIPTDIR}/manual_filtration.sh $PREFIX &>> $SCRIPTLOG
fi
bash ${SCRIPTDIR}/select_wes.sh $PREFIX &>> $SCRIPTLOG
bash ${SCRIPTDIR}/gt_refine.sh $PREFIX &>> $SCRIPTLOG

