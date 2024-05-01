import json
import os
import sys
import pandas as pd

def load_pipeline_config():
    try:
        full_path = os.path.join(os.getcwd(), "pipeline.config.json")
        f = open(full_path)
        config = json.load(f)
        return config
    except Exception as e:
        print('Failed to load pipeline config. Exiting...')
        sys.exit(1)

# Load Config
CONFIG = load_pipeline_config()
PROJECT = CONFIG["project"]

REF_GENOME = CONFIG["reference_genome"]
CELL_RANGER_VER = CONFIG["cellranger_version"]
TENX_ID = CONFIG["10X_id"]
TENX_KEY = CONFIG["10X_key"]
TENX_EXP = CONFIG["10X_exp"]

# Set-up Rule

rule retrieval_and_set_up:
    input:
        gr_ch_ref_gen_json = "reference_data/{folder_name}/reference.json".format(folder_name=REF_GENOME),
        cell_ranger_bin = "software/{bin}/bin/cellranger".format(bin=CELL_RANGER_VER),
        optitype_script = "software/optitype/OptiTypePipeline.py",
        kir_coordinate_file = "reference_data/kiridx/reference_data_rna_coord.fa",
        kir_reference_file = "reference_data/kiridx/reference_data_rna_seq.fa",
        ssbam_binary_path = "software/subset-bam-1.1.0/subset-bam" 
    shell:
        """
            echo "Installation complete."
        """


# Load Dependent Rules 
include: "rules/retrieve_t1k.smk"
include: "rules/retrieve_gencode_ref.smk"
include: "rules/retrieve_ipd_kir_ref.smk"
include: "rules/retrieve_ipd_hla_ref.smk"
include: "rules/retrieve_subset_bam.smk"
include: "rules/retrieve_cell_ranger_bin.smk"
include: "rules/retrieve_reference_genome.smk"
include: "rules/retrieve_optitype.smk"