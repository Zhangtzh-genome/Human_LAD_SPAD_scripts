#!/bin/bash

bedtools coverage -a ${Stage}.noXY.bed -b ${Stage}.merge.bam > ${Stage}.dep

samtools view -c ${Stage}.merge.bam 
# you will get the reads number N

#calculate strength
awk -v OFS="\t" '{print $4*1000000000/(($3-$2)*N),"'${Stage}'"}' ${Stage}.dep >> Strength.csv
