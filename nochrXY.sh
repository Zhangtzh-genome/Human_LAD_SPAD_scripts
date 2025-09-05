#!/bin/bash
### When calculate LADs/SPADs strength/length, we only consider autosomes.

mkdir -p tmp
for n in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22
do
	awk -v OFS="\t" '{if($1=="'$n'") print $1,$2,$3}' ${Stage}.final.bed >> tmp/${Stage}.${n}.noXY.bed
	cat tmp/${Stage}.${n}.noXY.bed >> ${Stage}.noXY.bed3.bed
done
