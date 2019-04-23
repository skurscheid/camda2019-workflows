rule md5check:
    threads:
        1
    benchmark:
        "{dataset}/benchmarks/{dsrc}_md5sum_times.tsv"
    input:
        file = "{dataset}/md5sums_{tcga_type}.tsv"
    output:
        md5sum = "{dataset}/md5sums_{tcga_type}_check.txt"
    shell:
        "md5sum --check {input.file} > {output.md5sum}"
