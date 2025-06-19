#!/bin/bash

Stage=8C

cat ${Stage}.repeat1.bed ${Stage}.repeat2.bed | sort -k1,1 -k2,2n -> ${Stage}.Merge_bed.1.bed
bedtools merge -d 100000 -i ${Stage}.Merge_bed.1.bed > ${Stage}.Merge_bed.bed
