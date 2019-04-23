rule decompress:
    conda:
        "../envs/fastqProcessing.yaml"
    params:
    threads:
        2
    input:
        file = "{dataset}/dsrc/{id}_{pe}.fastq.dsrc"
    output:
        pipe("{dataset}/pipes/{id}_{pe}.fifo")
    shell:
        "dsrc d -t{threads} {input.file} {output}"


rule fix_fastq_header_read1:
    params:
    threads:
        2
    input:
        "{dataset}/pipes/{id}_1.fifo"
    output:
        pipe("{dataset}/pipes/{id}_1.fixed.fifo")
    shell:
        "cat {input} | awk '{print (NR%4 == 1) ? $0 "/1" : $0}' | gzip -c > {ouput}"

rule fix_fastq_header_read2:
    params:
    threads:
        2
    input:
        "{dataset}/pipes/{id}_2.fifo"
    output:
        pipe("{dataset}/pipes/{id}_2.fixed.fifo")
    shell:
        "cat {input} | awk '{print (NR%4 == 1) ? $0 "/2" : $0}' | gzip -c > {ouput}"


rule qc_and_trim:
    params:
    conda:
        "../envs/fastqProcessing.yaml"
    threads:
        4
    input:
        read1 = "{dataset}/pipes/{id}_1.fixed.fifo",
        read2 = "{dataset}/pipes/{id}_2.fixed.fifo"
    output:
        read1 = "{dataset}/decompressed/{id}_1.fastq.gz",
        read2 = "{dataset}/decompressed/{id}_2.fastq.gz",
        json = "{dataset}/fastp_reports/{id}.json"
    shell:
        "fastp --in1 {input.read1} --in2 {input.read2} --out1 {output.read1} --out2 {output.read2} --detect_adapter_for_pe --json {output.json} --thread {threads}"

