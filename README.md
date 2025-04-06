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

```mermaid
flowchart TB
    subgraph " "
    subgraph params
    v0["api_key"]
    v1["sracode"]
    v7["ncbi_genome"]
    v4["adapter_path"]
    end
    v3([FastQC])
    v5([Fastp])
    v6([FastQC2])
    v8([GetGenome])
    v9([BWA])
    v10([GetStats])
    v0 --> v3
    v1 --> v3
    v0 --> v5
    v1 --> v5
    v4 --> v5
    v5 --> v6
    v7 --> v8
    v5 --> v9
    v8 --> v9
    v9 --> v10
    end
```
