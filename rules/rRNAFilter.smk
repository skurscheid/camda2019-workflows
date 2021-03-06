__author__ = "Sebastian Kurscheid (sebastian.kurscheid@anu.edu.au)"
__license__ = "MIT"
__date__ = "2019-05-01"

# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

"""
Rules for aligning reads with bowtie2 against a synthetic rRNA reference index
(https://github.com/BenLangmead/bowtie2)

For usage, include this in your workflow.
"""

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
        index = config["params"]["bowtie2"]["index"]["rRNA"],
        alconcgz = "{dataset}/rRNA_screen/{id}_blacklist_paired/{id}_aligned.fq.gz",
        algz = "{dataset}/rRNA_screen/{id}_blacklist_unpaired/{id}_aligned.fq.gz",
    input:
        read1 = "{dataset}/decompressed/{id}_1.fastq.gz",
        read2 = "{dataset}/decompressed/{id}_2.fastq.gz",
    output:
        bam = temp("{dataset}/rRNA_screen/{id}.bam"),
        blacklist_paired_dir = directory("{dataset}/rRNA_screen/{id}_blacklist_paired/"),
        blacklist_unpaired_dir = directory("{dataset}/rRNA_screen/{id}_blacklist_unpaired/")
    shell:
        """
            if [ ! -d {output.blacklist_paired_dir} ]; then mkdir -p {output.blacklist_paired_dir}; fi &&\
            if [ ! -d {output.blacklist_unpaired_dir} ]; then mkdir -p {output.blacklist_unpaired_dir}; fi &&\
            bowtie2 --very-sensitive-local -x {params.index} -1 {input.read1} -2 {input.read2}\
                    --threads {threads}\
                    --al-conc-gz {params.alconcgz}\
                    --un-conc-gz {output.blacklist_paired_dir}/{wildcards.id}_unaligned.fq.gz\
                    --al-gz {params.algz}\
                    --un-gz {output.blacklist_unpaired_dir}/{wildcards.id}_unaligned.fq.gz\
                    2>>{log}\
                    | samtools view -Sb - > {output.bam}
        """
