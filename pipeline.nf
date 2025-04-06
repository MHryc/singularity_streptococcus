#!/usr/bin/env nextflow

process GetGenome {
	input:
		path wget_infile

	output:
		path '*.fna.gz', emit: genome

	script:
	"""
	wget -nc -i ${wget_infile}
	"""
}
process FastQC {
	label 'fastqc'

	publishDir params.out, mode: 'link'

	input:
		tuple val(sra_id), path(reads_fastq)

	output:
		path "*.html"

	script:
	threads = reads_fastq.size()
	"""
	fastqc -t ${threads} ${reads_fastq}
	"""
}
process FastQC2 {
	label 'fastqc'

	publishDir params.out, mode: 'link'

	input:
		path(reads_fastq)

	output:
		path "*.html"

	script:
	threads = reads_fastq.size()
	"""
	fastqc -t ${threads} ${reads_fastq}
	"""
}
process Fastp {
	label 'fastp'

	input:
		tuple val(sra_id), path(reads_fastq)
		path adapter_path

	output:
		path "${sra_id}_?.fastp.fastq.gz"

	script:
	"""
	fastp -i ${reads_fastq[0]} -o ${sra_id}_1.fastp.fastq.gz -f 10 \
	-I ${reads_fastq[1]} -O ${sra_id}_2.fastp.fastq.gz -F 10 \
	-q 30 -u 40 -l 35 --trim_poly_x -z 4 --cut_tail \
	--cut_tail_window_size 1 --cut_tail_mean_quality 20 \
	--adapter_fasta ${adapter_path} \
	--html 'fastp_report.html' -R 'singularity_fastp' --thread 1
	"""
}
process BWA {
	label 'bwa'

	publishDir params.out, mode: 'link'

	input:
		path genome
		path trimmed_reads
	
	output:
		path 'mapped.sam'
	
	script:
	"""
	bwa-mem2 index ${genome}
	bwa-mem2 mem -t 8 ${genome} ${trimmed_reads.join(' ')} > mapped.sam
	"""
}
process GetStats {
	label 'samtools'

	publishDir params.out, mode: 'link'

	input:
		path mapped_reads

	output:
		path 'mapping_stats.tsv'
	
	script:
	"""
	samtools sort mapped.sam > mapped_sorted.sam
	samtools coverage mapped_sorted.sam >> mapping_stats.tsv
	samtools stats mapped_sorted.sam | head -n 46 >> mapping_stats.tsv
	"""
}

/*
 * Define pipeline parameters
 */

params.sracode = 'SRR32524951'
params.api_key = 'f4b36fd5a919b6f555c90a4b40078dcce408'
params.adapter_path = './'
params.ncbi_genome = ''
params.out = 'results/nextflow'

workflow run_QC {
	take:
	read_ch

	main:
	FastQC(read_ch)
	Fastp(read_ch, params.adapter_path)
	
	emit:
	trimmed_reads = Fastp.out
}

workflow {
	sra_ch = Channel.fromSRA(params.sracode, apiKey: params.api_key)

	run_QC(sra_ch)
		| FastQC2

	GetGenome(params.ncbi_genome)

	BWA(GetGenome.out, run_QC.out)
	| GetStats
}