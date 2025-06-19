#!/bin/bash

Type=LAD ###or SPAD.

species=hg19
celltype=${sample}
chrtype=${Type}s
binsize=100000

workplace=/path/to/your/workspace
sof=/path/to/your/Software
ref=/path/to/your/reference/${species}
out=${workplace}/${Type}/${sample}
trim=${sof}/Trimmomatic-0.39
trimadp=${sof}/Trimmomatic-0.39/adapters
picard=${sof}/picard-tools-2.5.0/picard.jar
chrhmm=${sof}/ChromHMM/ChromHMM.jar
genomesize=${sof}/ChromHMM/CHROMSIZES/${species}.txt

##Trim for QC##
java -jar ${trim}/trimmomatic-0.39.jar  PE -threads 5 -phred33 ${sample}_1.fq.gz ${sample}_2.fq.gz -baseout ${sample}.fq.gz ILLUMINACLIP:${trimadp}/NexteraPE-PE.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:36

##mapping
bowtie2 -p ${ppn} -q --phred33 --very-sensitive --end-to-end --no-unal --no-mixed --no-discordant -N 1 -X 3000 -x  ${ref}/${species}_index -1 ${sample}_1P.fq.gz -2 ${sample}_2P.fq.gz -S $sample.sam

samtools view -q 10 -h  $sample.sam > $sample.bam

rm $sample.sam

samtools sort $sample.bam -o $sample.sort.bam

rm $sample.bam

#dulplicate PCR#
##normal##
java -jar ${picard}  MarkDuplicates I=$sample.sort.bam O=${sample}.picard.bam METRICS_FILE=$sample.picard.bam.metrics REMOVE_DUPLICATES=TRUE
rm $sample.sort.bam
samtools index -b ${sample}.picard.bam

#for igv 
bamCoverage -bs ${binsize} --ignoreDuplicates --normalizeUsing RPKM -b ${sample}.picard.bam -o ${sample}_bs${binsize}.bw


### call LAD/SPAD
java -jar ${chrhmm} BinarizeBam -paired -p 0.05 -b ${binsize} ${genomesize} ${out} ${sample}.txt ${out}/${sample}_chrhmm
java -jar ${chrhmm} LearnModel -b ${binsize} -color 0,0,255 ${out}/${sample}_chrhmm ${out}/${sample}_chrhmm 2 ${species}
cat ${out}/${sample}_chrhmm/${celltype}_2_segments.bed|grep -E 'E2' > ${out}/${celltype}_E2_${chrtype}_bs${binsize}.binalpairbam.p0.05.bed
sed -i 's/E2/$Type/g' ${out}/${celltype}_E2_${chrtype}_bs${binsize}.binalpairbam.p0.05.bed
