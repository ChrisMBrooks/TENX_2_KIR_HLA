rule subset_alignment_map:
    input:
        binary_path = "software/subset-bam-1.1.0/subset-bam",
        barcode_list = "output/{project}/tenx_barcodes/barcodes_{batch_id}__{sample_id}.csv",
        completion_stamp = "output/{project}/cell_ranger_count/cell_ranger_completion_stamp_{batch_id}.txt"
    params:
        alignment_map = "output/{project}/cell_ranger_count/{batch_id}/outs/possorted_genome_bam.bam",
        thread_count = "16",
        barcode_tag = "CB"
    output:
        alignment_map = "output/{project}/subset-bam/{batch_id}__{sample_id}.bam"
    shell:
        """
            {input.binary_path} \
            --bam {params.alignment_map} \
            --cell-barcodes {input.barcode_list} \
            --out-bam {output.alignment_map} \
            --cores {params.thread_count} \
            --bam-tag {params.barcode_tag} \
            --log-level "debug"
        """