rule md5check:
    threads:
        1
    benchmark:
        "{dataset}/md5sum/benchmarks/{dsrc}_times.tsv"
    input:
        file = "{dataset}/{dsrc}"
    output:
        md5sum = "{dataset}/md5sum/{dsrc}.md5"
    shell:
        "md5sum {input.file} > {output.md5sum}"
