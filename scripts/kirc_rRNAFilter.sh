#!/bin/bash
#PBS -P kv78
#PBS -l walltime=24:00:00
#PBS -l wd
#PBS -q express
#PBS -e /home/150/sxk150/qsub_error
#PBS -o /home/150/sxk150/qsub_out
#PBS -l ncpus=1
#PBS -M skurscheid@gmail.com
#PBS -m abe

source ~/.bashrc

/short/rl2/miniconda3/envs/snakemake/bin/snakemake -s /home/150/sxk150/camda2019-workflows/Snakefile all_rRNAFilter_kirc\
    --configfile /home/150/sxk150/camda2019-workflows/config.yaml\
	--use-conda\
	--cluster "qsub -P {cluster.P}\
                    -l ncpus={cluster.ncpus} \
                    -q {cluster.queue} \
                    -l mem={cluster.mem} \
                    -l wd\
                    -l walltime={cluster.walltime}\
                    -M {cluster.M}\
                    -m {cluster.m}\
                    -e {cluster.error_out_dir} \
                    -o {cluster.std1_out_dir}" \
	--jobs 32\
	-d /short/kv78/\
	--rerun-incomplete \
        --local-cores 1\
	--cluster-config /home/150/sxk150/camda2019-workflows/cluster.json\
	-pr

