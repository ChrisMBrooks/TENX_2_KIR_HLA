rule subset_cell_ranger_libraries:
    input: 
        master_file = "input/master_library_definitions.csv",
        script_path = "scripts/subset_csv.py"
    params:
        subset_column = "sample",
        column_value = "{batch_id}",
        output_prefix = "cell_ranger_count_library",
        output_dir = "output/{project}/cell_ranger_libraries"
    output:
        subset_libary = "output/{project}/cell_ranger_libraries/cell_ranger_count_library_{batch_id}.csv"
    conda: "../envs/pandas_env.yml"
    shell:
        """
            python {input.script_path} \
            --input_file {input.master_file} \
            --subset_column {params.subset_column} \
            --column_value {params.column_value} \
            --output_prefix {params.output_prefix} \
            --output_dir {params.output_dir} \
            --header \
            --columns_to_include "*"
        """