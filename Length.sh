#!/bin/bash
for n in hPFC	hESC h2C h8C hM hB
do
	awk -v OFS="\t" '{print $3-$2,"'$n'"}' /path/to/${n}.Merge_bed.noXY.bed >> LAD_length_stage_noXY.csv

done
