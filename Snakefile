#configfile: "config.yaml"
report: "report/workflow.rst"

# Allow users to fix the underlying OS via singularity.
singularity: "docker://continuumio/miniconda3"

kirc_dsrc, = glob_wildcards("camda-tcga-kirc/dsrc/{ids}")
luad_dsrc, = glob_wildcards("camda-tcga-luad/dsrc/{ids}")
brca_dsrc, = glob_wildcards("camda-tcga-brca/dsrc/{ids}")

kirc_dsrc_file_id, = glob_wildcards("camda-tcga-kirc/dsrc/{ids}_1.fastq.dsrc")
luad_dsrc_file_id, = glob_wildcards("camda-tcga-luad/dsrc/{ids}_1.fastq.dsrc")
brca_dsrc_file_id, = glob_wildcards("camda-tcga-brca/dsrc/{ids}_1.fastq.dsrc")

# first stage
rule all_md5check_kirc:
    input:
        "camda-tcga-kirc/md5sums_KIRC_check.txt"

rule all_md5check_luad:
    input:
        "camda-tcga-kirc/md5sums_LUAD_check.txt"

rule all_md5check_brca:
    input:
        "camda-tcga-kirc/md5sums_BRCA_check.txt"

# second stage - presuming that all md5 checks are ok
rule all_fastqProcessing_kirc:
        expand("camda-tcga-kirc/decompressed/{id}_{pe}.fastq.gz",
               id = kirc_dsrc_file_id,
               pe = ["1", "2"]),
        expand("camda-tcga-kirc/fastp_reports/{id}.json",
               id = kirc_dsrc_file_id)

rule all_fastqProcessing_luad:
        expand("camda-tcga-luad/decompressed/{id}_{pe}.fastq.gz",
               id = luad_dsrc_file_id,
               pe = ["1", "2"]),
        expand("camda-tcga-luad/fastp_reports/{id}.json",
               id = luad_dsrc_file_id)

rule all_fastqProcessing_brca:
        expand("camda-tcga-brca/decompressed/{id}_{pe}.fastq.gz",
               id = brca_dsrc_file_id,
               pe = ["1", "2"]),
        expand("camda-tcga-brca/fastp_reports/{id}.json",
               id = brca_dsrc_file_id)

include: "rules/md5check.smk"
include: "rules/fastqProcessing.smk"