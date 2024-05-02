import json
import os
import sys
import pandas as pd

def load_sample_ids(barcode_filename:str):
    barcodes = pd.read_csv(barcode_filename, index_col=None)
    required_columns = ["batch_id", "sample_id"]
    barcodes = barcodes[required_columns]
    barcodes = barcodes.drop_duplicates(ignore_index=True)
    batch_ids = barcodes["batch_id"].tolist()
    sample_ids = barcodes["sample_id"].tolist()

    return batch_ids, sample_ids

def load_pipeline_config():
    try:
        full_path = os.path.join(os.getcwd(), "pipeline.config.json")
        f = open(full_path)
        config = json.load(f)
        return config
    except Exception as e:
        print('Failed to load pipeline config. Exiting...')
        sys.exit(1)

CONFIG = load_pipeline_config()
PROJECT = CONFIG["project"]

os.makedirs("output/{project}/logs".format(project=PROJECT), exist_ok=True)

BATCH_IDS, SAMPLE_IDS = load_sample_ids(
    barcode_filename = CONFIG["barcode_filename"]
)

LIBRARIES_FILENAME = CONFIG["libraries_filename"]

REF_GENOME = CONFIG["reference_genome"]
CELL_RANGER_VER = CONFIG["cellranger_version"]
TENX_ID = CONFIG["10X_id"]
TENX_KEY = CONFIG["10X_key"]
TENX_EXP = CONFIG["10X_exp"]
READ_TYPE = CONFIG["read_type"].lower()

rule all:
    input:
        hla_results = expand("output/{project}/hla_genotyping_results.csv", project=PROJECT),
        kir_results = expand("output/{project}/kir_genotyping_results.csv", project=PROJECT)
    shell:
        """
            echo "Complete!"
        
        """

rule kir_hla_genotype_sc_rna_seq:
    input:
        kir_results = expand("output/{project}/t1k/kir/T1K_{batch_id}__{sample_id}_genotype.tsv", zip,
            project=[PROJECT]*len(BATCH_IDS), 
            batch_id=BATCH_IDS,
            sample_id=SAMPLE_IDS
        ),
        hla_results = expand("output/{project}/optitype/{batch_id}__{sample_id}_hla_typing_result.tsv", zip,
            project=[PROJECT]*len(BATCH_IDS), 
            batch_id=BATCH_IDS,
            sample_id=SAMPLE_IDS
        ),
        script_path = "scripts/consolidate_results.py"
    params:
        input_hla_dir = "output/{project}/optitype",
        input_kir_dir = "output/{project}/t1k/kir",
        output_dir = "output/{project}"
    output:
        hla_results = "output/{project}/hla_genotyping_results.csv",
        kir_results = "output/{project}/kir_genotyping_results.csv"
    conda: "envs/pandas_env.yml"
    shell:
        """
            python {input.script_path} \
            --input_hla_dir {params.input_hla_dir} \
            --input_kir_dir {params.input_kir_dir} \
            --output_dir {params.output_dir} \
        """
 
# Load Dependent Rules 
include: "rules/subset_cell_ranger_libraries.smk"
include: "rules/align_sc_rna_seq.smk"
include: "rules/subset_alignment_map.smk"
include: "rules/subset_barcodes.smk"
include: "rules/subset_alignment_map_by_chr.smk"
include: "rules/hla_type_sc_rna_seq.smk"
include: "rules/kir_type_sc_rna_seq.smk"

# Set-up Rules
include: "rules/retrieve_t1k.smk"
include: "rules/retrieve_gencode_ref.smk"
include: "rules/retrieve_ipd_kir_ref.smk"
include: "rules/retrieve_ipd_hla_ref.smk"
include: "rules/retrieve_subset_bam.smk"
include: "rules/retrieve_cell_ranger_bin.smk"
include: "rules/retrieve_reference_genome.smk"
include: "rules/retrieve_optitype.smk"

localrules: all, kir_hla_genotype_sc_rna_seq, subset_alignment_map, subset_barcodes

# --- Future Additions ---
# 1.0 Pull / scrape allelle-freq.net
# 2.0 Compute summary Stats