
rule retrieve_t1k:
    params:
        t1k_url = "https://github.com/mourisl/T1K.git",
        software_dir = "software/t1k"
    output:
        t1k_build_file = "software/t1k/t1k-build.pl"
    shell:
        """
            git clone "{params.t1k_url}" {params.software_dir}           
        """