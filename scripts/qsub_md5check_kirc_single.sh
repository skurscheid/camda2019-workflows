#!/bin/bash
#PBS -P kv78
#PBS -l walltime=00:59:00
#PBS -l wd
#PBS -e /home/150/sxk150/qsub_error
#PBS -o /home/150/sxk150/qsub_out
#PBS -l ncpus=1

/short/rl2/miniconda3/envs/snakemake/bin/snakemake -s /home/150/sxk150/camda2019-workflows/Snakefile camda-tcga-kirc/md5sum/7193ae75-63cd-4b1f-bda8-f9a5451a528b_2.fastq.dsrc.md5\
	--use-conda\
	--cluster "qsub -P {cluster.P}\
                    -l ncpus={cluster.ncpus} \
                    -q {cluster.queue} \
                    -l mem={cluster.mem} \
                    -l wd\
                    -l walltime={cluster.walltime}\
                    -e {cluster.error_out_dir} \
                    -o {cluster.std1_out_dir}" \
	--jobs 32\
	-d /short/kv78/\
	--rerun-incomplete \
        --local-cores 1\
	--cluster-config /home/150/sxk150/camda2019-workflows/cluster.json\
	-pr

