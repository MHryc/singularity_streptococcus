# singularity_streptococcus
A short pipeline to showcase use of singularity containers

## *Analysis* steps
1. Download WGS reads from SRA with sra-tools
2. QC with FastQC
3. Read trimming with fastp
4. Post trimming FastQC

## Running
```
git clone https://github.com/MHryc/singularity_streptococcus.git
cd singularity_streptococcus/ && chmod +x pipeline.sh
./pipeline.sh
```

## Results
Html files created by FastQC and fastp will be stored in `/results` directory

## Workflow DAG

### run_QC DAG

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

### main workflow DAG

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
