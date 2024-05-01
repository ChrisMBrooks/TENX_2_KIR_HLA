
rule retrieve_gencode_ref:
    params:
        gencode_url = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_45/gencode.v45.annotation.gtf.gz",
        interim_gz = "reference_data/gencode/gencode.v45.annotation.gtf.gz"
    output:
        gencode_file = "reference_data/gencode/gencode.v45.annotation.gtf"
    shell:
        """
            curl --output "{params.interim_gz}" "{params.gencode_url}"
            gunzip -c "{params.interim_gz}" > "{output.gencode_file}"
        """
