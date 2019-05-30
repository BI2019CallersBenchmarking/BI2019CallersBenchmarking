
#!/bin/bash
rtg=/home/varia/Tools/rtg-tools/rtg-tools-3.10.1-4d58eadb/rtg
ref=/home/varia/MEGA/BI/Human_2019_project/human_g1k_v37.fasta
ref_template=/home/varia/MEGA/BI/Human_2019_project/hg19.sdf
cds=/home/varia/MEGA/BI/Human_2019_project/controls/cds.sorted.bed
output_dir=/home/varia/MEGA/BI/Human_2019_project/vcfevalretults
mkdir summ

for vcf in *.vcf.gz
do
	samplereg=`echo $vcf | grep -oP '^HG\d\d\d'`
	echo ${samplereg}
	echo ../controls/${samplereg}.bed
	$rtg vcfeval -b ../controls/${samplereg}*.vcf.gz -c ${vcf} -e ../controls/${samplereg}*.bed -t ${ref_template} \
	--bed-regions ${cds} -o summ/${vcf%%.vcf.gz} -f QUAL
done

cd summ

