#!/bin/bash
#PBS -P gp60
#PBS -l walltime=12:00:00
#PBS -l wd
#PBS -q normal
#PBS -e /home/150/sxk150/qsub_error
#PBS -o /home/150/sxk150/qsub_out
#PBS -l ncpus=1
#PBS -l mem=4GB
#PBS -M skurscheid@gmail.com
#PBS -m abe
#PBS -l storage=scratch/kv78

target=${cli_target}

source ~/.bashrc

/home/150/sxk150/miniconda3/envs/snakemake/bin/snakemake -s /home/150/sxk150/camda2019-workflows/Snakefile ${cli_target}\
    --configfile /home/150/sxk150/camda2019-workflows/config.yaml\
	--use-conda\
	--cluster "qsub -P {cluster.P}\
                    -l ncpus={threads} \
                    -q {cluster.queue} \
                    -l mem={cluster.mem} \
                    -l wd\
                    -l walltime={cluster.walltime}\
		    -l storage={cluster.storage}\
		    -l jobfs={cluster.jobfs}\
                    -M {cluster.M}\
                    -m {cluster.m}\
                    -e {cluster.error_out_dir} \
                    -o {cluster.std1_out_dir}" \
	--jobs 100\
	-d /scratch/kv78/camda-tcga\
	--rerun-incomplete \
    --local-cores 1\
	--cluster-config /home/150/sxk150/camda2019-workflows/cluster.json\
    --keep-going\
	-pr 

