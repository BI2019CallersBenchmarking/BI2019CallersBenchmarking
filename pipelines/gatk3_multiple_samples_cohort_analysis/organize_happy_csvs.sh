#!/bin/bash


mkdir summ
# in every hap.py output table, add filename at the start of line. It will be the rowname (sample name) in final table
for file in *.summary.csv
do
	filereg=${file%%.summary.csv}
	echo $filereg
	sed -e "s/^/${filereg},/g" ${file} > summ/${file%%.summary.csv}.csv
done

cd summ

cat *.csv > total.csv #concatenate multiple tables
grep -v 'TOTAL' total.csv > ttl.csv #remove extra headers
head -n 1 total.csv > header.csv #make one header
cat header.csv ttl.csv > fin.csv #concatenate header and table into final table
rm total.csv header.csv ttl.csv *summary.csv #clean up