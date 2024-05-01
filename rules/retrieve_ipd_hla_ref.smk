
rule retrieve_ipd_hla_ref:
    input:
        gencode_file = "reference_data/gencode/gencode.v45.annotation.gtf",
        t1k_build_file = "software/t1k/t1k-build.pl"
    params:
        software_dir = "software/t1k",
        output_dir = "reference_data/hlaidx"
    output:
        hla_ref = "reference_data/hlaidx/reference_data_rna_seq.fa",
        hla_coord = "reference_data/hlaidx/reference_data_rna_coord.fa"
    conda: "../envs/t1k_env.yml"
    shell:
        """          
            perl {input.t1k_build_file} -o {params.output_dir} --download IPD-IMGT/HLA
            perl {input.t1k_build_file} -o {params.output_dir} -d {params.output_dir}/hla.dat -g {input.gencode_file}
        """
