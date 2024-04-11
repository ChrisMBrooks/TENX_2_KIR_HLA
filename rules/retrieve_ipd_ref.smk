
rule retrieve_ipd_ref:
    params:
        gencode_url = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_45/gencode.v45.annotation.gtf.gz",
        t1k_url = "https://github.com/mourisl/T1K.git",
        interim_gz = "reference_data/gencode/gencode.v45.annotation.gtf.gz",
        software_dir = "software/t1k",
        output_dir = "reference_data"
    output:
        t1k_build_file = "software/t1k/t1k-build.pl",
        gencode_file = "reference_data/genecode/gencode.v45.annotation.gtf",
        hla_ref = "reference_data/hlaidx/hlaidx_rna_seq.fa",
        hla_coord = "reference_data/hlaidx/hlaidx_rna_coord.fa",
        kir_ref = "reference_data/kiridx/kiridx_rna_seq.fa",
        kir_coord = "reference_data/kiridx/kiridx_rna_coord.fa"
    conda: "../envs/t1k_env.yml"
    shell:
        """
            git clone -C {params.software_dir} {params.t1k_url}
            curl --output {params.interim_gz} "{params.gencode_url}"
            gunzip -c {params.interim_gz} > {output.gencode_file}
            perl {params.software_dir}/t1k-build.pl -o {params.output_dir}/hlaidx --download IPD-IMGT/HLA
            perl {params.software_dir}/t1k-build.pl -o {params.output_dir}/hlaidx -d {params.output_dir}/hlaidx/hla.dat -g {output.gencode_file}

            perl {params.software_dir}/t1k-build.pl -o {params.output_dir}/kiridx --download IPD-KIR
            perl {params.software_dir}/t1k-build.pl -o {params.output_dir}/kiridx -d {params.output_dir}/kiridx/kir.dat -g {output.gencode_file}
        """
