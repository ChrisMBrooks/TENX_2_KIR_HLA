
rule retrieve_subset_bam:
    params:
        url = "https://github.com/10XGenomics/subset-bam/releases/download/v1.1.0/subset-bam_linux"
    output:
        output_bin = "software/subset-bam-1.1.0/subset-bam"
    shell:
        """
            curl -L --output {output.output_bin} "{params.url}"
            chmod +x "{output.output_bin}"
        """
