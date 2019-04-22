#configfile: "config.yaml"
report: "report/workflow.rst"

# Allow users to fix the underlying OS via singularity.
singularity: "docker://continuumio/miniconda3"

kirc_dsrc = glob_wildcards("camda-tcga-kirc/{ids}.dsrc")
luad_dsrc = glob_wildcards("camda-tcga-luad/{ids}.dsrc")
brca_dsrc = glob_wildcards("camda-tcga-brca/{ids}.dsrc")

rule all_md5check_kirc:
    input:
        expand("camda-tcga-kirc/{dsrc}.md5",
               dsrc = kirc_dsrc)

rule all_md5check_luad:
    input:
        expand("camda-tcga-luad/{dsrc}.md5",
               dsrc = luad_dsrc)

rule all_md5check_brca:
    input:
        expand("camda-tcga-brca/{dsrc}.md5",
               dsrc = brca_dsrc)

include: "rules/md5check.smk"
