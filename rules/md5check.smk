rule md5check:
    threads:
        1
    benchmark:
        "{dataset}/benchmarks/{dsrc}_md5sum_times.tsv"
    input:
        file = "{dataset}/dsrc/{dsrc}"
    output:
        md5sum = "{dataset}/md5sum/{dsrc}.md5"
    shell:
        "md5sum {input.file} > {output.md5sum}"
