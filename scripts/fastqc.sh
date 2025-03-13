#!/bin/bash

cd /mnt/proj/$RUN_ID
fastqc -t 2 ${RUN_ID}_1.fastq ${RUN_ID}_2.fastq -o /mnt/proj/results/fastqc_out
