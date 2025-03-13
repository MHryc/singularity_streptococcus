#!/bin/bash

cd /mnt/proj/$RUN_ID

fastp -i ${RUN_ID}_1.fastq -o ${RUN_ID}_1.fastp.fastq -f 10 \
	-I ${RUN_ID}_2.fastq -O ${RUN_ID}_2.fastp.fastq -F 10 \
	-q 30 -u 40 -l 35 --trim_poly_x -z 4 --cut_tail \
	--cut_tail_window_size 1 --cut_tail_mean_quality 20 \
	--adapter_fasta /mnt/proj/resources/adapter.fa \
	--html 'fastp_report.html' -R 'singularity_fastp' --thread 1

mv /mnt/proj/$RUN_ID/fastp_report.html /mnt/proj/results/fastp_out
