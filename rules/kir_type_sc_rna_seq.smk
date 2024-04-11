rule kir_type_sc_rna_seq:
    input:
        alignment_file = "output/{project}/subset-bam/{batch_id}_{sample_id}.bam",
        coordinate_file = "reference_data/kiridx/kiridx_rna_coord.fa",
        reference_file = "reference_data/kiridx/kiridx_rna_seq.fa", 
    params:
        thread_count = "16",
        barcode_tag = "CB",
        output_dir = "output/{project}/t1k/kir"
    output:
        results = "output/{project}/t1k/kir/T1K_{batch_id}_{sample_id}_genotype.tsv"
    conda: "../envs/t1k_env.yml"
    shell:
        """
            run-t1k \
            -b {input.alignment_file} \
            -c {input.coordinate_file} \
            -f {input.reference_file} \
            -t {params.thread_count} \
            --barcode {params.barcode_tag} \
            --od {params.output_dir}
        """