#!/usr/bin/env nextflow

process FastQC {
	label 'fastqc'

    publishDir 'results/nextflow', mode: 'link'

	input:
		tuple val(sample_id), path(reads_fastq)

	output:
		path "*.html"

	script:
	threads = reads_fastq.size()
	"""
	fastqc -t ${threads} ${reads_fastq}
	"""
}

params.sracode = 'SRR32524951'
params.api_key = 'f4b36fd5a919b6f555c90a4b40078dcce408'

workflow {
    read_ch = channel.fromSRA(params.sracode, apiKey: params.api_key)
        .view()

    FastQC(read_ch)
}