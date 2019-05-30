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

To obtain precision-recall curves, we used VCFeval function of rtg-tools (https://github.com/RealTimeGenomics/rtg-tools) (Cleary et al., 2014)
Example of running comparison commands :
``` bash
$rtgtools vcfeval -b ${truth.vcf.gz} -c ${query.vcfgz} -e {truth_confidence_intervals}.bed -t ${reference_template} \
--bed-regions ${cds_regions.bed} -o ${output.dir} -f QUAL
```
## Results

When comparing the quality of the calling on one randomly selected sample (HG004), the best performance was shown by DEEPVARIANT, which provided the highest parameters of Precision and Recall with different cutoffs for the variant quality

![Figure1](/Figures/Figure1.png)

Figure 1. Precision/Recall curves plotted for HG004 sample for different callers



Next, we averaged the results over all analyzed samples, using F1 metric for quality evaluation. For indels, the previous version of GATK - GATK3 showed the best results, showing best performance than the new version, GATK4. For snps, DEEPVARIANT showed the best results.

![Figure2](/Figures/Figure2.png)

Figure 2. F1 metrics for different callers.



We also found that evaluated calling quality is highly dependent on a specific sample. Figure 3 represents F1 metrics for specific pipelines and specific samples. We tried to identify a factor affecting the quality of the calling, besides the calling pipeline.

![Figure3](/Figures/Figure3.png)

Figure 3. F1 metrics for different samples and for specific callers.



Interestingly, for most calling pipelines exomic experiments gave better results than genomic ones, which contradicts the available data, at least in the case of indels (Fang et al., 2014). Therefore, we assumed that there are other factors that have a greater influence on the calling.

![Figure4](/Figures/Figure4.png)

Figure 4. F1 metric boxplots for exomic and genomic experiments. 



We also supposed that calling performance may depend on average coverage, but we couldn't detect that for our samples, probably due to  insufficient sample number.

![Figure5](/Figures/Figure5.png)

Figure 5. Correlation between coverage and F1 metric for different callers.



Therefore, we suggested that other factors and their combinations may influence the resulting calling quality, but, to discover them, we need to increase our sample number. We still suppose that calling quality depends on average coverage, and we are planning to evaluate sensitivity of different callers to that parameter.

## Conclusions

1. Deep Variant and GATK3 showed the best results among callers
2. GATK4 has not yet performed better than GATK3, and needs some improvements.
3. Supposedly, the quality of calling depends on several parameters, including sample preparation, type of experiment and coverage, as well as their combination
4. And it also depends on the caller :)

## References
1. Fang, H., Wu, Y., Narzisi, G., O’Rawe, J.A., Barrón, L.T.J., Rosenbaum, J., Ronemus, M., Iossifov, I., Schatz, M.C., and Lyon, G.J. (2014). Reducing INDEL calling errors in whole genome and exome sequencing data. Genome Med 6.
2. Cleary, J.G., Braithwaite, R., Gaastra, K., Hilbush, B.S., Inglis, S., Irvine, S.A., Jackson, A., Littin, R., Nohzadeh-Malakshah, S., Rathod, M., et al. (2014). Joint variant and de novo mutation identification on pedigrees from high-throughput sequencing data. J. Comput. Biol. 21, 405–419.


