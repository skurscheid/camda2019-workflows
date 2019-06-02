rule bowtie2_rRNA: 
    version:
        1
    conda:
        "../envs/aligners.yaml"
    benchmark:
        "{dataset}/benchmarks/{id}_bowtie2_rRNA.tsv"
    log:
        "{dataset}/logs/{id}_bowtie2_rRNA.txt"
    threads:
        14
    params:
        index = config["params"]["bowtie2"]["index"]["rRNA"]
    input:
        read1 = "{dataset}/decompressed/{id}_1.fastq.gz",
        read2 = "{dataset}/decompressed/{id}_2.fastq.gz"
    output:
        bam = temp("{dataset}/rRNA_screen/{id}.bam"),
        metrics = "{dataset}/rRNA_screen/{id}_metrics.txt",
        alconcgz = "{dataset}/rRNA_screen/{id}_blacklist_paired_aligned.fq.gz",
        unconcgz = "{dataset}/rRNA_screen/{id}_blacklist_paired_unaligned.fq.gz",
        algz = "{dataset}/rRNA_screen/{id}_blacklist_unpaired_aligned.fq.gz",
        ungz = "{dataset}/rRNA_screen/{id}_blacklist_unpaired_unaligned.fq.gz"
    shell:
        """
            bowtie2 --quiet --very-sensitive-local -x {input.index} -1 {input.read1} -2 {input.read2}\
                    --threads {threads}\
                    --met-file {output.metrics}
                    --al-conc-gz {output.alconcgz}\
                    --un-conc-gz {output.unconcgz}\
                    --al-gz {output.algz}\
                    --un-gz {output.ungz}\
                    | samtools view -Sb - > {output.bam} 2>{log}
        """
