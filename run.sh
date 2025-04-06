#!/usr/bin/env bash

nextflow run pipeline.nf -resume \
	--sracode 'SRR32524951' \
	--api_key 'f4b36fd5a919b6f555c90a4b40078dcce408' \
	--adapter_path 'resources/adapter.fa' \
	--ncbi_genome 'resources/streptococus_ncbi.txt' \
	--out 'results/nextflow'
