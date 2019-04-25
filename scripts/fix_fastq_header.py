import os, uuid, sys
import io
from Bio.SeqIO.QualityIO import FastqGeneralIterator

fastq_file = snakemake.input.fastq
pair = snakemake.wildcards.pe
fixed_fastq_file = snakemake.output.fixed

def run_script():
    """ runs the script to append paired end information to fastq header"""
    try:
        out = gzip.open(fixed_fastq_file, "wt", compresslevel=4, newline="\n")
        with gzip.open(fastq_file, "rt") as handle:
        for title, sequence, quality in FastqGeneralIterator(handle):
            title = title + "/1"
            record = "\n".join([title, sequence, "+", quality])
            out.write(record)
        close(out)
    except Exception as e:
        print(e)

# Main method.
if __name__ == '__main__':
    run_script()