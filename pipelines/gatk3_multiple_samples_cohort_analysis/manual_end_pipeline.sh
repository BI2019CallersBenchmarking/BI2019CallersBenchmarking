#!/bin/bash

source ~/configure.cfg
SCRIPTDIR=~/SCRIPTS3
ENR=true
COHORT=true
PREFIX=$1
SCRIPTLOG=~/PREFIX/log
# if $ENR 
# then
ENRICHMENT=~/cds.intervals
# fi


bash ${SCRIPTDIR}/genotype_nonwes.sh $PREFIX &>> $SCRIPTLOG
bash ${SCRIPTDIR}/manual_filtration.sh $PREFIX &>> $SCRIPTLOG

bash ${SCRIPTDIR}/select_wes.sh $PREFIX &>> $SCRIPTLOG
bash ${SCRIPTDIR}/gt_refine.sh $PREFIX &>> $SCRIPTLOG

