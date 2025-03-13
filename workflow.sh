#!/bin/bash

# Utworzenie katalogu w partycją o większym rozmiarze
#mkdir ~/pl0217-01/project_data/containers_hryc
#ln -s ~/pl0217-01/project_data/containers_hryc/ .singularity/

#cd ~/pl0217-01/project_data/4_MHryc/containers/container_test

#DIR=$(readlink -f ~/pl0217-01/project_data)
#export WORK_DIR="4_MHryc/containers/container_test"
export WORK_DIR=$(readlink -f .)

chmod +x scripts/*

mkdir -p results/fastqc_out results/fastp_out

# Pobranie danych WGS Streptococcus pyogenes
export RUN_ID="SRR32524951"
NCBI_REF="streptococus_ncbi.txt"
SRA_TOOLS="https://depot.galaxyproject.org/singularity/sra-tools:3.2.0--h4304569_0"
#wget -nc -i $NCBI_REF -P ncbi_files

singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	$SRA_TOOLS bash -c /mnt/proj/scripts/sratools.sh

FASTQC="https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0"
singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	$FASTQC bash -c /mnt/proj/scripts/fastqc.sh

FASTP="https://depot.galaxyproject.org/singularity/fastp:0.24.0--heae3180_1"

singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	$FASTP bash -c /mnt/proj/scripts/fastp.sh
