# singularity_streptococcus
A short pipeline to showcase use of singularity containers.

## *Analysis* steps
1. Download WGS reads from SRA with sra-tools
2. QC with FastQC
3. Read trimming with fastp
4. Post trimming FastQC

## Bash version

```
git clone https://github.com/MHryc/singularity_streptococcus.git
cd singularity_streptococcus/ && chmod +x pipeline.sh
./pipeline.sh
```

### Results
Html files created by FastQC and fastp will be stored in `/results` directory

## Nextflow version

Modify the `run.sh` script:

```
nextflow run pipeline.nf -resume \
	--sracode 'SRR32524951' \
	--api_key 'f4b36fd5a919b6f555c90a4b40078dcce408' \
	--adapter_path "$(pwd)/resources/adapter.fa" \
	--ncbi_genome "$(pwd)/resources/streptococus_ncbi.txt" \
	--out 'results/nextflow'
```

```
--scracode      SRA code of reads to download and analyse
--api_key       NCBI API key
--adapter_path  path to FASTA file containing adapter sequence
--ncbi_genome   textfile containing URL of genomic.fna.gz file from NCBI genomes
--out           directory where results will be stored
```

and `./run.sh`

### Workflow structure (DAGs)

#### run_QC DAG

```mermaid
flowchart TB
    subgraph run_QC
    subgraph take
    v0["read_ch"]
    end
    v1([FastQC])
    v2([Fastp])
    subgraph emit
    v3["trimmed_reads"]
    end
    v0 --> v1
    v0 --> v2
    v2 --> v3
    end
```

#### main workflow DAG

```mermaid
flowchart TB
    subgraph " "
    subgraph params
    v0["api_key"]
    v1["sracode"]
    v5["ncbi_genome"]
    end
    v3([run_QC])
    v4([FastQC2])
    v6([GetGenome])
    v7([BWA])
    v8([GetStats])
    v0 --> v3
    v1 --> v3
    v3 --> v4
    v5 --> v6
    v3 --> v7
    v6 --> v7
    v7 --> v8
    end
```
