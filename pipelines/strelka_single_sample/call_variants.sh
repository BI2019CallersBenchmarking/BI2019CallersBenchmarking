#!/bin/bash

# call varinats with strelka2
DATENOW=$( date )
echo "Started calling varinats with strelka2 at: $DATENOW"

for BAM in *.dedup.bam
do
	SAMPLE=${BAM%%.dedup.bam}

	STRELKA_DIR="../vcfs/${SAMPLE}"
	STRELKA_RUN="../vcfs/${SAMPLE}/runWorkflow.py"

    if [ ! -d "$STRELKA_DIR" ]; then
    	mkdir "${STRELKA_DIR}"
    	"${STRELKA_CONFIG}" --bam="${BAM}" --referenceFasta="${REFERENCE}" --callRegions="${CDS}" --runDir="${STRELKA_DIR}" --exome
    	"${STRELKA_RUN}" -m local -j 16
	fi
	
done
wait

DATENOW=$( date )
echo "Finished calling varinats with strelka2 at: $DATENOW"