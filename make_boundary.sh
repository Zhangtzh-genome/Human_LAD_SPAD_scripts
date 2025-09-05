#!/bin/bash

bed=/path/to/LADs_or_SPADs
for n in hESC #hPFC
	#h2C h8C hM hB
do
	awk -v OFS="\t" '{print $1,$2-20000,$2+20000,"LB","1","+"}' ${bed}/${n}.Merge_bed.noXY.bed > Boundary/${n}.Merge_bed.noXY.LB.bed
	awk -v OFS="\t" '{print $1,$3-20000,$3+20000,"RB","2","-"}' ${bed}/${n}.Merge_bed.noXY.bed > Boundary/${n}.Merge_bed.noXY.RB.bed
	cat Boundary/${n}.Merge_bed.noXY.LB.bed Boundary/${n}.Merge_bed.noXY.RB.bed |sort -k1,1V -k2,2g -k3,3g > Boundary/${n}.Merge_bed.noXY.Boundary.bed
done
