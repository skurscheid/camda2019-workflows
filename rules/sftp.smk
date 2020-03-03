__author__ = "Sebastian Kurscheid (sebastian.kurscheid@anu.edu.au)"
__license__ = "MIT"
__date__ = "2020-03-03"

# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

"""
Rules for downloading sequence files from CAMDA repository
see https://snakemake.readthedocs.io/en/stable/snakefiles/remote_files.html#file-transfer-over-ssh-sftp
and http://contest.camda.info/
For usage, include this in your workflow.
"""


SFTP = RemoteProvider(username="camda2019", password="MassiveData0724")

rule get_single_files_via_sftp:
    threads:
        1
    params:
        username="camda2019", password="MassiveData0724"
    input: 
        ...
    output:
        "{dataset}/dsrc/{file_id}.fastq.dsrc"
    shell:
        "lftp sftp://{params.username}:{params.password}@igenomed.stanford.edu -e \"pget -c /Users/camda2019/CAMDA/{wildcards.dataset}/{wildcards.file_id}.fastq.dsrc -o {output}; bye\""

