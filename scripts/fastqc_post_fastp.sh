#!/bin/bash

cd /mnt/proj/$RUN_ID
fastqc -t 2 ${RUN_ID}_1.fastp.fastq ${RUN_ID}_2.fastp.fastq -o /mnt/proj/results/fastqc_out
