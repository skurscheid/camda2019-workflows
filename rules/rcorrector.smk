__author__ = "Sebastian Kurscheid (sebastian.kurscheid@anu.edu.au)"
__license__ = "MIT"
__date__ = "2020-02-25"

# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

"""
Rules for removing erroneous kmers from Illumina reads using Rcorrector
(https://github.com/mourisl/Rcorrector)

For usage, include this in your workflow.
"""

rule run_Rcorrector: 
    version:
        1
    conda:
        "../envs/rcorrector.yaml"
    benchmark:
        "{dataset}/benchmarks/{id}_Rcorrector.tsv"
    log:
        "{dataset}/logs/Rcorrector/{id}_log.txt"
    threads:
        4
    params:
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
