rule align_rRNA:
    version:
        1
    conda:
        "../envs/aligners.yaml"
    params:
    threads:
        16
    input:
        index = "",
        read1 = "",
        read2 = ""
    output:
        bam = temp("{dataset}/rRNA_screen/{sample}.bam"),
        metrics = "{dataset}/rRNA_screen/{sample}_metrics.txt",
        al-conc-gz = "{dataset}/rRNA_screen/{sample}_blacklist_paired_aligned.fq.gz",
        un-conc-gz = "{dataset}/rRNA_screen/{sample}_blacklist_paired_unaligned.fq.gz",
        al-gz = "{dataset}/rRNA_screen/{sample}_blacklist_unpaired_aligned.fq.gz",
        un-gz = "{dataset}/rRNA_screen/{sample}_blacklist_unpaired_unaligned.fq.gz"
    shell:
        """
            bowtie2 --quiet --very-sensitive-local -x {input.index} -1 {input.read1} -2 {input.read2}\
                    --threads {threads}\
                    --met-file {output.metrics}
                    --al-conc-gz {output.al-conc-gz}\
                    --un-conc-gz {output.un-conc-gz}\
                    --al-gz {output.al-gz}\
                    --un-gz {output.un-gz}\
                    | samtools view -Sb - > {output.bam}
        """

    
