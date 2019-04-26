rule decompress:
    """ decompresses dsrc compressed fastq files"""
    conda:
        "../envs/fastqProcessing.yaml"
    benchmark:
        "{dataset}/benchmarks/decompress_{id}_{pe}_times.tsv"
    log:
        "{dataset}/logs/decompress/log_{id}_{pe}.txt"
    threads:
        4
    input:
        file = "{dataset}/dsrc/{id}_{pe}.fastq.dsrc"
    output:
        temp("{dataset}/fixed/{id}_{pe}.fastq.gz")
    shell:
        """dsrc d -t{threads} -s {input.file} | awk '{{print (NR%4 == 1) ? $0 "/1" : $0}}' | gzip -c > {output} 2>{log}"""

rule qc_and_trim:
    conda:
        "../envs/fastqProcessing.yaml"
    threads:
        8
    log:
        "{dataset}/logs/qc_and_trim/log_{id}.txt"
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
          fastp --in1 {input.read1} --in2 {input.read2} \
                --out1 {output.read1} --out2 {output.read2} \
                --detect_adapter_for_pe\
                --json {output.json}\
                --thread {threads}\
                2>{log}
        """
