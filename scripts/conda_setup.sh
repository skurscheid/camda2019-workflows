#!/bin/bash
#PBS -P kv78
#PBS -l walltime=00:20:00
#PBS -l wd
#PBS -e /home/150/sxk150/qsub_error
#PBS -o /home/150/sxk150/qsub_out
#PBS -l ncpus=1
#PBS -M skurscheid@gmail.com
#PBS -m abe
#PBS -N conda_setup
#PBS -q copyq

source ~/.bashrc

/short/rl2/miniconda3/envs/snakemake/bin/snakemake -s /home/150/sxk150/camda2019-workflows/Snakefile conda_setup\
        --use-conda\
        --jobs 1\
        -d /short/kv78/\
        --local-cores 1\
        -pr

