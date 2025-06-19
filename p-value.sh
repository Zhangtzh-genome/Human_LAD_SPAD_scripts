#!/bin/bash
usage="sh <script.sh> <path> <bed_file> <bam_file> <number of mapped reads>"
if [ $# -ne 4 ]; then
        echo "$usage"
        exit
fi

dataplcae=$1
bedfile=$2
bamfile=$3
N=$4

cd ${dataplcae}

bedtools coverage -a ${bedfile} -b ${bamfile} > ${bedfile}.dep

##human
awk '{print $0 "\t" int('${N}'*($3-$2)/2700000000) + 1}' ${bedfile}.dep > ${bedfile}.dep.tmp
#2662525997
#awk '{print $0 "\t" int('${N}'*($3-$2)/2662525997) + 1}' ${bedfile}.dep > ${bedfile}.dep.tmp
awk '{print $5"\t"$9}' ${bedfile}.dep.tmp > ${bedfile}.reads.lambda.txt

python p-value.py ${bedfile}.reads.lambda.txt ${bedfile}.p-value.tmp

paste ${bedfile} ${bedfile}.p-value.tmp > ${bedfile}.p-value.txt

awk '{if ($7 <= 0.05) print $1"\t"$2"\t"$3"\t"$4"\t"$7}' ${bedfile}.p-value.txt > ${bedfile}.p-value.final.bed

rm ${bedfile}.dep.tmp
rm ${bedfile}.reads.lambda.txt
rm ${bedfile}.p-value.tmp
rm ${bedfile}.p-value.txt
