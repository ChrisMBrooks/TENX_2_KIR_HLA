rule align_sc_rna_seq:
    input:
        ref_gen_json = "reference_data/{folder_name}/reference.json".format(folder_name=REF_GENOME),
        cell_ranger_bin = "software/{bin}/bin/cellranger".format(bin=CELL_RANGER_VER),
        library_file = "output/{project}/cell_ranger_libraries/cell_ranger_count_library_{batch_id}.csv"
    params:
        ref_genome_path = "reference_data/{folder_name}".format(folder_name=REF_GENOME),
        batch_id = "{batch_id}",
        output_dir = "output/{project}/cell_ranger_count/{batch_id}",
        memory_count_gb = "64",
        thread_count = "18",
        alignment_map = "output/{project}/cell_ranger_count/{batch_id}/outs/possorted_genome_bam.bam"
    output:
        completion_stamp = "output/{project}/cell_ranger_count/cell_ranger_completion_stamp_{batch_id}.txt"
    shell:
        """
            {input.cell_ranger_bin} count \
            --id={params.batch_id} \
            --transcriptome {params.ref_genome_path} \
            --libraries {input.library_file} \
            --localmem {params.memory_count_gb} \
            --localcores {params.thread_count} \
            --create-bam true \
            --output-dir {params.output_dir}\
            --nosecondary \
            --disable-ui

            if [ -f "{params.alignment_map}" ]; then
                echo "Creating completion stamp: {output.completion_stamp}."
                touch "{output.completion_stamp}"
            fi
        """
# Cellrnager needs to create the output directory itself otherwise it throws
# a pipestance error. To get around this upon completion of cr count, we use 
# the touch completion_stamp to create a placeholder output file. To resume
# execution without deleting cellranger progress, this file, alongside any 
# lock files, would need to be deleted prior to rerunning snakemake.