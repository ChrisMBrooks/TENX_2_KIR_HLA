rule retrieve_reference_genome:
    params:
        genome_file = REF_GENOME,
        url = "https://cf.10xgenomics.com/supp/cell-exp/{folder_name}.tar.gz".format(folder_name=REF_GENOME),
        output_dir = "reference_data"
    output:
        interim_tar = "reference_data/{folder_name}.tar.gz".format(folder_name=REF_GENOME),
        output_json = "reference_data/{folder_name}/reference.json".format(folder_name=REF_GENOME)
    shell:
        """ 
            curl --output {output.interim_tar} {params.url}
            tar -xzf {output.interim_tar} -C {params.output_dir}
        """

