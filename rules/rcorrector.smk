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
    shell:
        """

        """
