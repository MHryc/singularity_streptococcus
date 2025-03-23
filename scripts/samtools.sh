#!/bin/bash

cd /mnt/proj/results

samtools sort mapped.sam > mapped_sorted.sam
samtools coverage mapped_sorted.sam >> stats.tsv
samtools stats mapped_sorted.sam | head -n 46 >> stats.tsv
