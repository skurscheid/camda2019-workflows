#!/bin/bash
#PBS -P kv78
#PBS -l walltime=24:00:00
#PBS -l wd
#PBS -e /home/150/sxk150/qsub_error
#PBS -o /home/150/sxk150/qsub_out
#PBS -l ncpus=1
#PBS -M skurscheid@gmail.com
#PBS -m abe
#PBS -q express
#PBS -N kirc_fastq_processing_master

source ~/.bashrc

/short/rl2/miniconda3/envs/snakemake/bin/snakemake -s /home/150/sxk150/camda2019-workflows/Snakefile all_fastqProcessing_luad\
	--use-conda\
	--cluster "qsub -P {cluster.P}\
                    -l ncpus={cluster.ncpus}\
                    -q {cluster.queue}\
                    -l mem={cluster.mem}\
                    -l wd\
                    -l walltime={cluster.walltime}\
                    -M {cluster.M}\
                    -m {cluster.m}\
                    -e {cluster.error_out_dir}\
                    -o {cluster.std1_out_dir}\
                    -N {cluster.name}"\
	--jobs 128\
	-d /short/kv78/\
        --local-cores 1\
	--cluster-config /home/150/sxk150/camda2019-workflows/cluster.json\
	-pr
