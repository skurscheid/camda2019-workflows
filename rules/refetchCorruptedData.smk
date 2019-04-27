from snakemake.remote.SFTP import RemoteProvider
SFTP = RemoteProvider(username="camda", password="camdac4md4")

rule re_fetch_corrupted:
    params:
    threads: 1
    input:
        SFTP.remote("ala.boku.ac.ak:/data/CAMDA_TCGA/{file}")
    output:
        "{dataset}/{file}"
    run:
    """
        cp {input} {ouput}
    """

