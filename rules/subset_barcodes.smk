rule subset_barcodes:
    input: 
        master_file = "input/master_barcodes.csv",
        script_path = "scripts/subset_csv.py"
    params:
        subset_column = "batch_id,sample",
        column_value = "{batch_id},{sample_id}",
        columns_to_include = "barcode",
        output_prefix = "barcodes",
        output_dir = "output/{project}/10x_barcodes"
    output:
        subset_libary = "output/{project}/tenx_barcodes/barcodes_{batch_id}_{sample_id}.csv"
    conda: "../envs/pandas_env.yml"
    shell:
        """
            python {input.script_path} \
            --input_file {input.master_file} \
            --subset_column {params.subset_column} \
            --column_value {params.column_value} \
            --output_prefix {params.output_prefix} \
            --output_dir {params.output_dir} \
            --header
            --columns_to_include {params.columns_to_include}
        """