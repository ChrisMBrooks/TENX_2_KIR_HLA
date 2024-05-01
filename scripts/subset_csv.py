import argparse
import os
import sys
import pandas as pd
import numpy as np

def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Script to split a csv file by entry within a specified column.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser._action_groups.pop()
    required = parser.add_argument_group("required arguments")

    required.add_argument(
        "-i",
        "--input_file",
        help="full path filename as .csv",
        required=True,
        type=str,
    )

    required.add_argument(
        "-c",
        "--subset_columns",
        help="Column name(s) to use for file subsetting as str (e.g. 'column1,column2').",
        required=True,
        type=str,
    )

    required.add_argument(
        "-v",
        "--column_values",
        help="Value(s) within column to use for file subsetting as str (e.g. 'value1,value2').",
        required=True,
        type=str,
    )

    required.add_argument(
        "-ci",
        "--columns_to_include",
        help="Column name(s) to preserve in the output file as str (e.g. 'column1,column2'). Use '*' to include all.",
        required=True,
        type=str,
    )

    required.add_argument(
        "-hd",
        "--header",
        help="Include header in output file.",
        required=False,
        action='store_true',
    )

    required.add_argument(
        "-op",
        "--output_prefix",
        help="Filename prefix for the output file(s) as str.",
        required=True,
        type=str,
    )

    required.add_argument(
        "-o",
        "--output_dir",
        help="Output directory as string.",
        required=True,
        type=str,
    )
    
    return vars(parser.parse_args())

def main():
    # Parse Inputs
    args = parse_arguments()
    input_filename = args["input_file"]
    columns_of_interest = args["subset_columns"].split(",")
    column_values = args["column_values"].split(",")
    output_prefix = args["output_prefix"]
    output_dir = args["output_dir"]
    include_header = args["header"]
    columns_to_include = args["columns_to_include"]
    if columns_to_include == "*":
        columns_to_include = False
    else:
        columns_to_include = columns_to_include.split(",")
    
    #Load CSV
    input_frame = pd.read_csv(input_filename, index_col=None)

    subset_frame = input_frame
    for index, column_value in enumerate(column_values):
        column_of_interest = columns_of_interest[index]

        # Subset CSV by Unique Entry
        subset_frame = subset_frame[subset_frame[column_of_interest] == column_value]
    
    # Filter columns (if required)
    if columns_to_include:
        subset_frame = subset_frame[columns_to_include]

    # Format output filename
    filename_template = "{prefix}_{joined_keys}.csv"
    joined_keys = "__".join(column_values)
    filename = filename_template.format(
        prefix = output_prefix,
        joined_keys = joined_keys
    )
        
    # Export CSV
    full_path_filename = os.path.join(output_dir, filename)

    if include_header:
        subset_frame.to_csv(full_path_filename, index=None)
    else:
        subset_frame.to_csv(full_path_filename, index=None, header=None)

try:
    print('Starting...')   
    main()
    print('Complete.')   
except Exception as e:
    print('Script failed for the following reason:')
    print(e)
    print('Exiting...')
    sys.exit(1)
