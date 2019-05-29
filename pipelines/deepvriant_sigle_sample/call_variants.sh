#!/bin/bash

# call varinats with strelka2
DATENOW=$( date )
echo "Started calling varinats with deepvariant at: $DATENOW"

for BAM in *.dedup.bam
do
	SAMPLE=${BAM%%.dedup.bam}

    DEEPVARIANT_DIR="../vcfs/"
    DEEPVARIANT_VCF="../vcfs/${SAMPLE}_DEEPVARIANT_0.7.2.vcf"
    EXAMPLES_OUTPUT="${DEEPVARIANT_DIR}${SAMPLE}_output.tfrecord.gz"

    time seq 0 $((N_SHARDS-1)) | \
    parallel --eta --halt 2 \
    docker run \
    -v ${HOME}:${HOME} \
    gcr.io/deepvariant-docker/deepvariant:0.7.2 \
    /opt/deepvariant/bin/make_examples \
    --mode calling \
    --ref "${REFERENCE}" \
    --reads "${BAM}" \
    --examples "${DEEPVARIANT_DIR}${SAMPLE}examples.tfrecord@${N_SHARDS}.gz" \
    --regions "${PADDED_BED}" \
    --task {}

    docker run -v ${HOME}:${HOME} gcr.io/deepvariant-docker/deepvariant:0.7.2 /opt/deepvariant/bin/call_variants \
    --outfile "${EXAMPLES_OUTPUT}" \
    --examples "${DEEPVARIANT_DIR}${SAMPLE}examples.tfrecord@${N_SHARDS}.gz" \
    --checkpoint "${DEEPVARIANT_MODEL}"

    docker run -v ${HOME}:${HOME} gcr.io/deepvariant-docker/deepvariant:0.7.2 /opt/deepvariant/bin/postprocess_variants \
    --ref "${REFERENCE}" --infile "${EXAMPLES_OUTPUT}" --outfile "${DEEPVARIANT_VCF}"
	
done
wait

DATENOW=$( date )
echo "Finished calling varinats with deepvariant at: $DATENOW"