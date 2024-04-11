rule align_sc_rna_seq:
    input:
        ref_gen_json = "reference_data/{folder_name}/reference.json".format(folder_name=REF_GENOME),
        cell_ranger_bin = "software/{bin}/bin/cellranger".format(bin=CELL_RANGER_VER),
        library_file = "output/{project}/cell_ranger_libraries/cell_ranger_count_library_{batch_id}.csv"
    params:
        ref_genome_path = "reference_data/{folder_name}".format(folder_name=REF_GENOME),
        batch_id = "{batch_id}",
        output_dir = "output/{project}/cell_ranger_count/{batch_id}",
        memory_count_gb = "16",
        thread_count = "16"
    output:
        alignment_map = "output/{project}/cell_ranger_count/{batch_id}/outs/possorted_genome_bam.bam"
    shell:
        """
            {input.cell_ranger_bin} count \
            --id={params.batch_id} \
            --transcriptome {params.ref_genome_path} \
            --libraries $LIB_PATH \
            --localmem {params.memory_count_gb} \
            --localcores {params.thread_count} \
            --output-dir {params.output_dir}\
            --nosecondary \
            --disable-ui 
        """