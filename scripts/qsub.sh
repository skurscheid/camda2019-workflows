#~/bin/bash
# -P kv78
# -l walltime=00:59:00
# -l wd
# -e /home/150/sxk150/qsub_error
# -o /home/150/sxk150/qsub_out
# -l ncpus=1

/short/rl2/miniconda3/envs/snakemake/bin/snakemake -s Snakefile all_md5check_kirc\
	--use-conda\
	--cluster "qsub -P {cluster.P}\
                    -l ncpus={cluster.ncpus} \
                    -q {cluster.queue} \
                    -l mem={cluster.mem} \
                    -l wd\
                    -l walltime={cluster.walltime}
                    -e {cluster.error_out_dir} \
                    -o {cluster.std1_out_dir}" \
	--jobs 32\
	-d /short/kv78/\
	--rerun-incomplete \
    --local-cores 1\
	--cluster-config /home/150/sxk150/camda2019-workflows\
	-prn