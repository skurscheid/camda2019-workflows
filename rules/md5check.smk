rule md5check:
    threads:
        1
    params:
        directory = lambda wildcards: wildcards.dataset,
        file = lambda wildcards: "md5sums_" + wildcards.tcga_type + ".tsv"
    benchmark:
        "{dataset}/benchmarks/{tcga_type}_md5sum_times.tsv"
    input:
        file = "{dataset}/md5sums_{tcga_type}.tsv"
    output:
        md5sum = "{dataset}/md5sums_{tcga_type}_check.txt"
    shell:
        "cd {params.directory}; md5sum --check {params.file} > ../{output.md5sum}"
