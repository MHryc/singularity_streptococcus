#!/bin/bash

cd /mnt/proj/ncbi_files

bwa-mem2 index *.fna.gz
bwa-mem2 mem -t 8 *.fna.gz /mnt/proj/SRR32524951/SRR32524951_1.fastp.fastq /mnt/proj/SRR32524951/SRR32524951_2.fastp.fastq > mapped.sam
