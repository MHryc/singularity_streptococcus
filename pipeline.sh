#!/bin/bash

inform() {
        echo ========================================
        echo = $1
        echo ========================================
}

inform "Przygotowanie środowiska"
chmod +x scripts/*
mkdir -p results/fastqc_out results/fastp_out

inform "Pobieranie genomu referencyjnego"
export WORK_DIR=$(readlink -f .)
export RUN_ID="SRR32524951"
NCBI_REF="streptococus_ncbi.txt"
wget -nc -i resources/$NCBI_REF -P ncbi_files

inform "Pobieranie odczytów - sra-tools"
SRA_TOOLS="https://depot.galaxyproject.org/singularity/sra-tools:3.2.0--h4304569_0"
singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	$SRA_TOOLS bash -c /mnt/proj/scripts/sratools.sh

inform "FastQC przed przycinaniem"
FASTQC="https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0"
singularity instance start --bind "$WORK_DIR:/mnt/proj" $FASTQC fastqc

singularity exec instance://fastqc bash -c /mnt/proj/scripts/fastqc.sh

inform "Przycinanie adapterów - fastp"
FASTP="https://depot.galaxyproject.org/singularity/fastp:0.24.0--heae3180_1"
singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	$FASTP bash -c /mnt/proj/scripts/fastp.sh

inform "FastQC po przycinaniu"
singularity exec instance://fastqc bash -c /mnt/proj/scripts/fastqc_post_fastp.sh
singularity instance stop fastqc

inform "Indeksowanie referencji i mapowanie - BWA"
BWA="https://depot.galaxyproject.org/singularity/bwa-mem2:2.2.1--he70b90d_6"
singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	$BWA bash -c /mnt/proj/scripts/bwa.sh

rclone move ncbi_files/mapped.sam results/ --progress --multi-thread-streams=2

inform "Sortowanie i wyciągniecię podstawowych statystyk - samtools"
singularity pull samtools.sif docker://staphb/samtools
singularity exec \
	--bind "$WORK_DIR:/mnt/proj" \
	samtools.sif bash -c /mnt/proj/scripts/samtools.sh

inform "Wykresy, zmapowane odczyty i statystyki umieszczono w katalogu results/"
