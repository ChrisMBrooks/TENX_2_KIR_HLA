# snakemake --cores 8 --use-conda --conda-frontend conda --rerun-incomplete --until "parse_cell_ranger_libraries"
# snakemake --cores 8 --use-conda --conda-frontend conda --rerun-incomplete
# snakemake --cores 8 --use-conda --conda-frontend conda --dry-run
# snakemake --cores 8 --use-conda --conda-frontend conda --keep-incomplete
#--printshellcmds

import json, os, sys
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
MASTER_BARCODE_FILENAME = CONFIG["barcode_filename"]
REF_GENOME = CONFIG["reference_genome"]
CELL_RANGER_VER = CONFIG["cellranger_version"]
TENX_ID = CONFIG["10X_id"]
TENX_KEY = CONFIG["10X_key"]
TENX_EXP = CONFIG["10X_exp"]
BATCH_IDS = ["2292GEX_1", "2292GEX_2"]
SAMPLE_IDS = ["2292GEX_1", "2292GEX_2"]

rule kir_genotype_sc_rna_seq:
    input:
        results = expand("output/{project}/t1k/kir/T1K_{batch_id}_{sample_id}_genotype.tsv", zip,
            project=[PROJECT]*len(BATCH_IDS), 
            batch_id=BATCH_IDS,
            sample_id=SAMPLE_IDS
        )
    shell:
        """
            echo "Complete!"
        """

rule hla_genotype_sc_rna_seq:
    input:
        results = expand("output/{project}/optitype/{batch_id}_{sample_id}_hla_typing_result.tsv", zip,
            project=PROJECT, 
            batch_id=BATCH_IDS,
            sample_id=SAMPLE_IDS
        )
    shell:
        """
            echo "Complete!"
        """

# Aggregate Results
# Pull / scrape allelle-freq.net
# Compute summary Stats 

include: "rules/retrieve_ipd_ref.smk"
include: "rules/retrieve_subset_bam.smk"
include: "rules/retrieve_cell_ranger_bin.smk"
include: "rules/retrieve_reference_genome.smk"
include: "rules/retrieve_optitype.smk"
include: "rules/subset_cell_ranger_libraries.smk"
include: "rules/align_sc_rna_seq.smk"
include: "rules/subset_alignment_map.smk"
include: "rules/subset_barcodes.smk"
include: "rules/subset_alignment_map_by_chr.smk"
include: "rules/hla_type_sc_rna_seq.smk"
include: "rules/kir_type_sc_rna_seq.smk"

