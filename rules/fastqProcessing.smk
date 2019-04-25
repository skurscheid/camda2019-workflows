rule decompress:
    """ decompresses dsrc compressed fastq files"""
    group:
        "A"
    conda:
        "../envs/fastqProcessing.yaml"
    benchmark:
        "{dataset}/benchmarks/decompress_{id}_{pe}_times.tsv"
    threads:
        2
    input:
        file = "{dataset}/dsrc/{id}_{pe}.fastq.dsrc"
    output:
        pipe("{dataset}/temp/{id}_{pe}.fastq")
    shell:
        "dsrc d -t{threads} {input.file} {output}"

rule fix_fastq_header_read1:
    group:
        "A"
    threads:
        3
    benchmark:
        "{dataset}/benchmarks/fix_fastq_{id}_1_times.tsv"
    input:
        "{dataset}/temp/{id}_1.fastq"
    output:
        temp("{dataset}/temp/{id}_1.fixed.fastq.gz")
    shell:
        """
          cat {input} | awk '{{print (NR%4 == 1) ? $0 "/1" : $0}}' | gzip -c > {output}
        """

rule fix_fastq_header_read2:
    group:
        "A"
    threads:
        3
    benchmark:
        "{dataset}/benchmarks/fix_fastq_{id}_2_times.tsv"
    input:
        "{dataset}/temp/{id}_2.fastq"
    output:
        temp("{dataset}/temp/{id}_2.fixed.fastq.gz")
    shell:
        """
          cat {input} | awk '{{print (NR%4 == 1) ? $0 "/2" : $0}}' | gzip -c > {output}
        """

rule qc_and_trim:
    conda:
        "../envs/fastqProcessing.yaml"
    threads:
        4
    benchmark:
        "{dataset}/benchmarks/qc_and_trim_{id}_times.tsv"
    input:
        read1 = "{dataset}/temp/{id}_1.fixed.fastq.gz",
        read2 = "{dataset}/temp/{id}_2.fixed.fastq.gz"
    output:
        read1 = "{dataset}/decompressed/{id}_1.fastq.gz",
        read2 = "{dataset}/decompressed/{id}_2.fastq.gz",
        json = "{dataset}/fastp_reports/{id}.json"
    shell:
        "fastp --in1 {input.read1} --in2 {input.read2} --out1 {output.read1} --out2 {output.read2} --detect_adapter_for_pe --json {output.json} --thread {threads}"

