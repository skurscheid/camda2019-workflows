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
        metrics = "{dataset}/rRNA_screen/{id}.metrics.txt",
        alconcgz = "{dataset}/rRNA_screen/{id}_blacklist_paired/{id}_aligned.fq.gz",
        unconcgz = "{dataset}/rRNA_screen/{id}_blacklist_paired/{id}_unaligned.fq.gz",
        algz = "{dataset}/rRNA_screen/{id}_blacklist_unpaired/{id}_aligned.fq.gz",
        ungz = "{dataset}/rRNA_screen/{id}_blacklist_unpaired/{id}_unaligned.fq.gz"
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
            bowtie2 --quiet --very-sensitive-local -x {params.index} -1 {input.read1} -2 {input.read2}\
                    --threads {threads}\
                    --met-file {params.metrics}\
                    --al-conc-gz {params.alconcgz}\
                    --un-conc-gz {params.unconcgz}\
                    --al-gz {params.algz}\
                    --un-gz {params.ungz}\
                    | samtools view -Sb - > {output.bam} 2>{log}
        """
