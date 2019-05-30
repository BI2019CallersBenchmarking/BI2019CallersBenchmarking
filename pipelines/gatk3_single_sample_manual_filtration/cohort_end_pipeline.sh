#!/bin/bash

source ~/configure.cfg
SCRIPTDIR=~/SCRIPTS3
ENR=true
COHORT=true
PREFIX=$1
SCRIPTLOG=~/PREFIX/log

ENRICHMENT=~/cds.intervals

cd 

bash ${SCRIPTDIR}/genotype_wes.sh $PREFIX &>> $SCRIPTLOG
bash ${SCRIPTDIR}/vqsr.sh $PREFIX &>> $SCRIPTLOG
bash ${SCRIPTDIR}/select_wes.sh $PREFIX &>> $SCRIPTLOG
bash ${SCRIPTDIR}/gt_refine.sh $PREFIX &>> $SCRIPTLOG

