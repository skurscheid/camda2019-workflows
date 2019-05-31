rule align_rRNA:
    version:
        1
    conda:
        "../envs/aligners.yaml"
    params:
    benchmark:
        "{dataset}/benchmarks/{id}_bowtie2_rRNA.tsv"
    log:
        "{dataset}/logs/{id}_bowtie2_rRNA.txt"
    threads:
        14
    input:
        index = config["params"]["bowtie2"]["index"]["rRNA"],
        read1 = "{dataset}/decompressed/{id}_1.fastq.gz",
        read2 = "{dataset}/decompressed/{id}_2.fastq.gz",
    output:
        bam = temp("{dataset}/rRNA_screen/{id}.bam"),
        metrics = "{dataset}/rRNA_screen/{id}_metrics.txt",
        al-conc-gz = "{dataset}/rRNA_screen/{id}_blacklist_paired_aligned.fq.gz",
        un-conc-gz = "{dataset}/rRNA_screen/{id}_blacklist_paired_unaligned.fq.gz",
        al-gz = "{dataset}/rRNA_screen/{id}_blacklist_unpaired_aligned.fq.gz",
        un-gz = "{dataset}/rRNA_screen/{id}_blacklist_unpaired_unaligned.fq.gz"
    shell:
        """
            bowtie2 --quiet --very-sensitive-local -x {input.index} -1 {input.read1} -2 {input.read2}\
                    --threads {threads}\
                    --met-file {output.metrics}
                    --al-conc-gz {output.al-conc-gz}\
                    --un-conc-gz {output.un-conc-gz}\
                    --al-gz {output.al-gz}\
                    --un-gz {output.un-gz}\
                    | samtools view -Sb - > {output.bam} 2>{log}
        """