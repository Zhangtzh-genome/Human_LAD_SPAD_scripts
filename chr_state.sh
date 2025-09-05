#!/bin/bash

spad=/path/to/SPAD/Analysis/MergeBed
lad=/path/to/LAD/Analysis/MergeBed

mkdir -p tmp

for n in h8C hM hB hESC hPFC
do
	### LAD
	bedtools intersect -a ~/SD1/reference/hg19/hg19.chrnoXY.bs100k.bed -b ${n}.L.Merge_bed.noXY.bed -v > tmp/${n}_nonLADs.bs100k.bed
	bedtools makewindows -b ${n}.L.Merge_bed.noXY.bed -w 100000 > tmp/${n}.L.Merge_bed.noXY.bs100k.bed
	awk -v OFS="\t" '{print $0,0}' tmp/${n}_nonLADs.bs100k.bed > tmp/${n}_nonLADs.bs100k.0.bed
	awk -v OFS="\t" '{print $0,1}' tmp/${n}.L.Merge_bed.noXY.bs100k.bed > tmp/${n}.L.Merge_bed.noXY.bs100k.1.bed
	cat tmp/${n}_nonLADs.bs100k.0.bed tmp/${n}.L.Merge_bed.noXY.bs100k.1.bed > tmp/${n}.L.state.bed
	bedtools sort -i tmp/${n}.L.state.bed > tmp/${n}.L.state.sort.bed
	### SPAD
	bedtools intersect -a ~/SD1/reference/hg19/hg19.chrnoXY.bs100k.bed -b ${n}.S.Merge_bed.noXY.bed.p-value.final.bed -v > tmp/${n}_nonSPADs.bs100k.bed
	bedtools makewindows -b ${n}.S.Merge_bed.noXY.bed.p-value.final.bed -w 100000 > tmp/${n}.S.Merge_bed.noXY.bs100k.bed
	awk -v OFS="\t" '{print $0,0}' tmp/${n}_nonSPADs.bs100k.bed > tmp/${n}_nonSPADs.bs100k.0.bed
	awk -v OFS="\t" '{print $0,2}' tmp/${n}.S.Merge_bed.noXY.bs100k.bed > tmp/${n}.S.Merge_bed.noXY.bs100k.2.bed
	cat tmp/${n}_nonSPADs.bs100k.0.bed tmp/${n}.S.Merge_bed.noXY.bs100k.2.bed > tmp/${n}.S.state.bed
	bedtools sort -i tmp/${n}.S.state.bed > tmp/${n}.S.state.sort.bed

	paste tmp/${n}.L.state.sort.bed tmp/${n}.S.state.sort.bed | awk -v OFS="\t" '{print $1,$2,$3,$4+$8}' - > ${n}.chr.state.bed
	 
done

paste h8C.chr.state.bed hM.chr.state.bed hB.chr.state.bed hESC.chr.state.bed hPFC.chr.state.bed > 5_stage.chr.state.bed
awk -v OFS="\t" '{print $1,$2,$3,$4,$8,$12,$16,$20}' 5_stage.chr.state.bed > 5_stage.chr.state.final.bed

### get LAD&SPAD in each stage
for n in h8C hM hB hESC hPFC
do
	bedtools intersect -a ${n}.L.Merge_bed.noXY.bed -b ${n}.S.Merge_bed.noXY.bed.p-value.final.bed > ${n}.LAD_SPAD.bed
done

### For alluvium plot
for n in h8C hM hB hESC hPFC
do
	awk -v OFS="\t" 'BEGIN{sum = 1}{print "'$n'",$4,sum; sum += 1}' ${n}.chr.state.bed >> five.stage.chr.stage.csv
done
