#!/bin/bash

# Utworzenie katalogu w partycją o większym rozmiarze
#mkdir ~/pl0217-01/project_data/containers_hryc
#ln -s ~/pl0217-01/project_data/containers_hryc/ .singularity/

#cd ~/pl0217-01/project_data/4_MHryc/containers/container_test

#DIR=$(readlink -f ~/pl0217-01/project_data)
#export WORK_DIR="4_MHryc/containers/container_test"
export WORK_DIR=$(readlink -f .)

# Pobranie danych WGS Streptococcus pyogenes
export RUN_ID="SRR32524951"
NCBI_REF="streptococus_ncbi.txt"
SRA_TOOLS="https://depot.galaxyproject.org/singularity/sra-tools:3.2.0--h4304569_0"
#wget -nc -i $NCBI_REF -P ncbi_files

singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	--bind "scripts:/mnt/scripts" \
	$SRA_TOOLS \
	bash -c /mnt/scripts/sratools.sh

FASTQC="https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0"
singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	--bind "scripts:/mnt/scripts" \
	$FASTQC bash -c /mnt/scripts/fastqc.sh

FASTP="https://depot.galaxyproject.org/singularity/fastp:0.24.0--heae3180_1"

#singularity run $FASTP eval "fastp \
#	-i ${RUN_ID}_1.fastq -o ${RUN_ID}_1.fastp.fastq \
#	-I ${RUN_ID}_2.fastq -O ${RUN_ID}_2.fastp.fastq \
#	-q 30 -u 40 -l 35 --trim_poly_x -z 4 \
#	--cut_tail --cut_tail_window_size 1 --cut_tail_mean_quality 20 \
#	--adapter_fasta adapter.fa --html -R 'singularity_fastp' --thread 1"
