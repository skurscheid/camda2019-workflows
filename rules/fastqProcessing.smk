rule decompress:
    """ decompresses dsrc compressed fastq files"""
    conda:
        "../envs/fastqProcessing.yaml"
    benchmark:
        "{dataset}/benchmarks/decompress_{id}_{pe}_times.tsv"
    threads:
        4
    input:
        file = "{dataset}/dsrc/{id}_{pe}.fastq.dsrc"
    output:
        temp("{dataset}/fixed/{id}_{pe}.fastq.gz")
    shell:
        """dsrc d -t{threads} {input.file} | awk '{{print (NR%4 == 1) ? $0 "/1" : $0}}' | gzip -c > {output}"""

rule qc_and_trim:
    conda:
        "../envs/fastqProcessing.yaml"
    threads:
        8
    benchmark:
        "{dataset}/benchmarks/qc_and_trim_{id}_times.tsv"
    input:
        read1 = "{dataset}/fixed/{id}_1.fastq.gz",
        read2 = "{dataset}/fixed/{id}_2.fastq.gz"
    output:
        read1 = "{dataset}/decompressed/{id}_1.fastq.gz",
        read2 = "{dataset}/decompressed/{id}_2.fastq.gz",
        json = "{dataset}/fastp_reports/{id}.json"
    shell:
        """
          fastp --in1 {input.read1} --in2 {input.read2} --out1 {output.read1} --out2 {output.read2} --detect_adapter_for_pe --json {output.json} --thread {threads}
        """
