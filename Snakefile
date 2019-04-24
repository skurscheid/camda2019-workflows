# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.
import pandas as pd
import os
from snakemake.utils import validate, min_version

##### set minimum snakemake version #####
#
min_version("5.1.2")
#

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
        "camda-tcga-luad/md5sums_LUAD_check.txt"

rule all_md5check_brca:
    input:
        "camda-tcga-brca/md5sums_BRCA_check.txt"

# second stage - presuming that all md5 checks are ok
rule all_fastqProcessing_kirc:
    input:
        expand("camda-tcga-kirc/decompressed/{id}_{pe}.fastq.gz",
               id = kirc_dsrc_file_id,
               pe = ["1", "2"]),
        expand("camda-tcga-kirc/fastp_reports/{id}.json",
               id = kirc_dsrc_file_id)

# trial run
kirc_trial_ids = ["00327c92-7745-4794-bef2-6174ba790253",
                  "00946310-0f66-42a9-a373-aba13cfa87e9",
                  "00c8f6ab-9678-4414-8799-5b8df3109018",
                  "018462d8-3ccb-4c08-aef5-3d91540cc693",
                  "018cdacc-dad1-406f-ae45-1c15be6c6a57",
                  "018f6cc2-b8ba-4abf-826f-4cc2f7243412",
                  "023ac154-d967-434f-b868-7083bd57d71b",
                  "024da484-7267-4c31-8ac4-5e9a1c26ea69",
                  "029475c1-7115-45fe-985c-f96857ad78af",
                  "02b8bc07-b070-4b42-afab-3dcfc7aa1ab6",
                  "02d17427-b107-4494-9eee-4e421a3a112a",
                  "0322e00f-c1bd-45de-91f4-79140d960c87",
                  "049364a6-3999-4f8e-ba9c-36be85f4edad",
                  "0498d769-43e9-49a4-9a47-3cdc6326ed9f",
                  "04bd5447-cefa-410e-bac8-f93cae48c4bf",
                  "04c5d16d-049f-4b54-991b-921264eb0fb4",
                  "0527193f-3a1b-4245-bbed-77d2df3f1e84",
                  "05508bee-fccc-4399-a66e-eaf16b150346",
                  "05aa5795-13a0-49fa-99c7-f299d48acc0b",
                  "05ec3300-358b-474e-94d1-492e366a930d"]

rule trial_fastqProcessing_kirc:
    input:
        expand("camda-tcga-kirc/decompressed/{id}_{pe}.fastq.gz",
               id = kirc_trial_ids,
               pe = ["1", "2"]),
        expand("camda-tcga-kirc/fastp_reports/{id}.json",
               id = kirc_trial_ids)

rule all_fastqProcessing_luad:
    input:
        expand("camda-tcga-luad/decompressed/{id}_{pe}.fastq.gz",
               id = luad_dsrc_file_id,
               pe = ["1", "2"]),
        expand("camda-tcga-luad/fastp_reports/{id}.json",
               id = luad_dsrc_file_id)

rule all_fastqProcessing_brca:
    input:
        expand("camda-tcga-brca/decompressed/{id}_{pe}.fastq.gz",
               id = brca_dsrc_file_id,
               pe = ["1", "2"]),
        expand("camda-tcga-brca/fastp_reports/{id}.json",
               id = brca_dsrc_file_id)

include: "rules/md5check.smk"
include: "rules/fastqProcessing.smk"
