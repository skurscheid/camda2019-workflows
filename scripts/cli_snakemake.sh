/home/150/sxk150/miniconda3/envs/snakemake/bin/snakemake -s /home/150/sxk150/camda2019-workflows/Snakefile ${1}\
    --configfile /home/150/sxk150/camda2019-workflows/config.yaml\
	--use-conda\
	-d /scratch/kv78/camda2019-tcga\
	--rerun-incomplete \
        --local-cores 1\
	--cluster-config /home/150/sxk150/camda2019-workflows/cluster.json\
        --keep-going\
	-pr ${2}
