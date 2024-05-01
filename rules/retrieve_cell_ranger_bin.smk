rule retrieve_cell_ranger_bin:
    params:
        interim_tar = "software/{bin}.tar.gz".format(bin=CELL_RANGER_VER),
        url = "https://cf.10xgenomics.com/releases/cell-exp/{version}.tar.gz?Expires={expiration_date}&Key-Pair-Id={identifier}&Signature={key}".format(
            version=CELL_RANGER_VER, 
            expiration_date=TENX_EXP, 
            identifier=TENX_ID, 
            key=TENX_KEY
        ),
        output_dir = "software"
    output:
        output_bin = "software/{bin}/cellranger".format(bin=CELL_RANGER_VER)
    shell:
        """
            curl --output {params.interim_tar} "{params.url}"
            tar -xzf {params.interim_tar} -C {params.output_dir}
            chmod +x {output.output_bin}
        """