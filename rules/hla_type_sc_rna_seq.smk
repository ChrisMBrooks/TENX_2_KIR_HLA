if READ_TYPE == "paired":

    rule hla_type_sc_rna_seq:
        input:
            script = "software/optitype/OptiTypePipeline.py",
            fastq1 = "output/{project}/arcas_hla/{batch_id}__{sample_id}.extracted.1.fq.gz",
            fastq2 = "output/{project}/arcas_hla/{batch_id}__{sample_id}.extracted.2.fq.gz"
        params:
            config_file = "envs/optitype_config0.ini",
            prefix = "{batch_id}__{sample_id}_hla_typing",
            output_dir = "output/{project}/optitype"
        output:
            results = "output/{project}/optitype/{batch_id}__{sample_id}_hla_typing_result.tsv"
        conda: "../envs/optitype_env.yml"
        shell:
            """
                module load samtools/1.2
                
                python {input.script} \
                --input "{input.fastq1} {input.fastq2}" \
                --outdir {params.output_dir} \
                --prefix {params.prefix} \
                --rna \
                --verbose \
                --config "{params.config_file}"
            """
else:

    rule hla_type_sc_rna_seq:
        input:
            script = "software/optitype/OptiTypePipeline.py",
            fastq = "output/{project}/arcas_hla/{batch_id}__{sample_id}.extracted.fq.gz"
        params:
            config_file = "envs/optitype_config0.ini",
            prefix = "{batch_id}__{sample_id}_hla_typing",
            output_dir = "output/{project}/optitype"
        output:
            results = "output/{project}/optitype/{batch_id}__{sample_id}_hla_typing_result.tsv"
        conda: "../envs/optitype_env.yml"
        shell:
            """
                module load samtools/1.2
                
                python {input.script} \
                --input {input.fastq} \
                --outdir {params.output_dir} \
                --prefix {params.prefix} \
                --rna \
                --verbose \
                --config "{params.config_file}"
            """
