#!/bin/bash

cd /mnt/proj/$WORK_DIR/$RUN_ID
mkdir ../fastqc_out
fastqc -t 2 ${RUN_ID}_1.fastq ${RUN_ID}_2.fastq -o ../fastqc_out
