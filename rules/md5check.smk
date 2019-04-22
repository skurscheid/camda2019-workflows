rule md5check:
    threads:
        1
    input:
        file = "{dataset}/{dsrc}"
    output:
        md5sum = "{dataset}/{dsrc}.md5"
    shell:
        "md5sum {input.file} > {output.md5um}"
