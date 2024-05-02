import argparse
import os
import re
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
        "-hi",
        "--input_hla_dir",
        help="full path directory name for KIR typing results, as str.",
        required=True,
        type=str,
    )

    required.add_argument(
        "-ki",
        "--input_kir_dir",
        help="full path directory name for HLA typing results, as str.",
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

def load_kir_results(input_dir:str) -> pd.DataFrame:

    pattern = r"T1K_(\S+)__(\S+)_genotype.tsv"
    frames = []
    for filename in os.listdir(input_dir):
        matches = re.findall(pattern, filename)
        if len(matches) > 0:
            batch_id = matches[0][0]
            sample_id = matches[0][1]

            full_path = os.path.join(input_dir, filename)

            results_frame = pd.read_csv(full_path, index_col=None, header=None, delimiter='\t')
            columns = ["kir_gene", "allele_count", "allele_candidates", "abundance", "quality_score", "alt_allele_candidates", "alt_abundance", "alt_quality_score", "something"]
            results_frame = pd.DataFrame(results_frame.values, columns=columns)
            results_frame = results_frame[["kir_gene", "allele_count", "abundance", "quality_score"]]
            results_frame["batch_id"] = batch_id
            results_frame["sample_id"] = sample_id
            frames.append(results_frame)
        
    consolidated_results = pd.concat(frames, ignore_index=True)
    return consolidated_results
    
def load_hla_results(input_dir:str) -> pd.DataFrame:

    pattern = r"(\S+)__(\S+)_hla_typing_result.tsv"
    frames = []
    for filename in os.listdir(input_dir):
        matches = re.findall(pattern, filename)
        if len(matches) > 0:
            batch_id = matches[0][0]
            sample_id = matches[0][1]

            fullpath_filename = os.path.join(input_dir, filename)
            frame = pd.read_csv(fullpath_filename, index_col=0, sep="\t")
            frame["batch_id"] = batch_id
            frame["sample_id"] = sample_id
            frames.append(frame)
        
    consolidated_results = pd.concat(frames, ignore_index=True)
    return consolidated_results
        
def main():
    # Parse Inputs
    args = parse_arguments()
    input_hla_dir = args["input_hla_dir"]
    input_kir_dir = args["input_kir_dir"]
    output_dir = args["output_dir"]

    # Load, Consolidate, Export KIR Results
    kir_results = load_kir_results(input_dir=input_kir_dir)
    output_filename = os.path.join(output_dir, "kir_genotyping_results.csv")
    kir_results.to_csv(output_filename)

    # Load, Consolidate, Export HLA Results
    hla_results = load_hla_results(input_dir=input_hla_dir)
    output_filename = os.path.join(output_dir, "hla_genotyping_results.csv")
    hla_results.to_csv(output_filename)

try:
    print('Starting...')   
    main()
    print('Complete.')   
except Exception as e:
    print('Script failed for the following reason:')
    print(e)
    print('Exiting...')
    sys.exit(1)
