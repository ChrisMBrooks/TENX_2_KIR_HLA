rule subset_alignment_by_chr:
    input:
        alignment_map = "output/{project}/subset-bam/{batch_id}_{sample_id}.bam"
    params:
        thread_count = "24",
        output_dir = "output/{project}/arcas_hla"
    output:
        fastq1 = "output/{project}/arcas_hla/{batch_id}_{sample_id}.extracted.1.fq.gz",
        fastq2 = "output/{project}/arcas_hla/{batch_id}_{sample_id}.extracted.2.fq.gz"
    conda: "../envs/arcas_hla_env.yml"
    shell:
        """
            arcasHLA extract \
            --unmapped \
            --outdir {params.output_dir} \
            --temp $TMPDIR \
            --threads {params.thread_count} \
            --verbose \
            {input.alignment_map}
        """