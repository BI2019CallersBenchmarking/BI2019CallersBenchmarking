# Environment construction for exome sequencing data processing

## Description
Exome sequencing is the technology of sequencing all protein-coding genes in genome, i.e.,sequencing of all exones. 
It is obvious that most of the possible variations of interest are concentrated in these loci. The obtained reads, of course, need to be handled somehow. 
The processing of raw reads generally includes alignment, assessing the quality of alignment, calling, and then filtering out the identified indels and snps using various mechanisms. The output should represent a vcf file containing a list of variants that characterize one or several samples. In a whole, these pipelines are necessary to decide on specific variants found during sequencing, if these variants are artifacts of sequencing or alignment or they are real substitutions and indels in the genome. When analyzing the genomes, especially when searching for substitutions and indels associated with human diseases, the accuracy with which the calling of variants takes place is extremely important. Our goal was to evaluate this accuracy in different versions of calling pipelines.

## Goals and objectives
The main goal of this project is to compare different pipelines of exome variant calling
The objectives of the project:
1) To develop a pipeline for the variant calling based on the GDK4 WDL reference scripts.
2) To get to know the different variant callers and benchmark them using the Genome In A Bottle and SynDip datasets, to optimize the parameters for optimal performance.
## Methods

### Necessary software

* [GATK.3.X](https://software.broadinstitute.org/gatk/download/archive)
* [GATK4.1.2.0](https://software.broadinstitute.org/gatk/download/index)
* [SAMTOOLS.1.9](https://github.com/samtools/samtools/releases/tag/1.9)
* [BCFTOOLS.1.9](https://github.com/samtools/bcftools/releases/tag/1.9)
* [PICARD.2.19.2](https://github.com/broadinstitute/picard/releases/tag/2.19.2)
* [STRELKA.2.9.10](https://github.com/Illumina/strelka/releases/tag/v2.9.10)
* [DEEPVARIANT.0.7.2](https://github.com/google/deepvariant/releases/tag/v0.7.2)
* [FREEBAYES.1.2.0](https://github.com/ekg/freebayes/releases/tag/v1.2.0)
* [HAP.PY.0.3.9](https://github.com/Illumina/hap.py/releases/tag/v0.3.9)
* [RTGTOOLS.3.10.1](https://github.com/RealTimeGenomics/rtg-tools/releases/tag/3.10.1)
* [BWA.0.7.17](https://github.com/lh3/bwa/releases/tag/v0.7.17)

### How to run

Examples of scripts to run variant callers are in the folder [pipelines](https://github.com/BI2019CallersBenchmarking/BI2019CallersBenchmarking/tree/master/pipelines) folder

### Benchmark datasets

For evaluating the accuracy of small variant callers we used the following dastasets

* [SynDip.0.5](https://github.com/lh3/CHM-eval/releases/tag/v0.5)
* [NIST.3.3.2](https://github.com/genome-in-a-bottle/giab_latest_release)

Specific samples, average coverage, sequencing kit, sequencer , experiment type are shown in the table below.

| source | average coverage | sequencing kit | sequencer | experiment type |
| --- | --- | --- | --- | --- |
| [HG001-1]() | 73.4254 | Nextera Rapid Capture Exome and Expanded Exome | HiSeq2500 | Exome |
| [HG001-2]() | 80.9454 | SeqCap EZ Human Exome Library v3.0 | HiSeq2500 | Exome |
| [HG001-3]() | 113.437 | SeqCap EZ Exome SeqCap v2 | HiSeq 2000 | Exome |
| [HG001-4]() | 105.819 | SureSelect v2 |HiSeq 2000 | Exome |
| [HG001-5]() | 67.4065 | SeqCap EZ Human Exome Library v3.0 | HiSeq 2000 | Exome |
| [HG005]() | 186.532 | Agilent SureSelect Human All Exon V5 kit | HiSeq 2500 | Exome |
| [HG006]() | 34.6326 | Illumina TruSeq (LT) DNA PCR-Free Sample Prep Kits (FC-121-3001) | HiSeq 2500 | Genome |
| [HG007]() | 35.349 | Illumina TruSeq (LT) DNA PCR-Free Sample Prep Kits (FC-121-3001) | HiSeq 2500 | Genome |
| [HG002]() | 232.056 | Agilent SureSelect Human All Exon V5 kit | HiSeq 2500 | Exome |
| [HG003]() | 197.668 | Agilent SureSelect Human All Exon V5 kit | HiSeq 2500 | Exome |
| [HG004]() | 219.84 | Agilent SureSelect Human All Exon V5 kit | HiSeq 2500 | Exome |
| [SynDip]() | 41.9519 | Kapa Biosystems reagents |  | Genome |

### How to compare
To compare the obtained results of variant calling with reference samples, we used [HAP.PY.0.3.9](https://github.com/Illumina/hap.py/releases/tag/v0.3.9).
Example of running comparison commands :
``` bash
	python2.7 ${happy} ${truth_vcf} ${vcf} -f ${truth_bed} -r ${ref} --engine=vcfeval \
  --engine-vcfeval-template ${ref_template} --roc QUAL -T ${cds} --threads 16 -o ${output_dir}/{$output_filename}
```
## Results


When comparing the quality of the calling on one randomly selected sample (HG004), the best performance was shown by DEEPVARIANT, which provided the highest parameters of Precision and Recall with different cutoffs for the variant quality

