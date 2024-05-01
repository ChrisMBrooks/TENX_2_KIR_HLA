
rule retrieve_optitype:
    params:
        url = "https://github.com/FRED-2/OptiType.git",
        modified_script = "scripts/modified_OptiTypePipeline.py",
        output_dir = "software/optitype"
    output:
        output_script = "software/optitype/OptiTypePipeline.py" 
    shell:
        """
            git clone "{params.url}" {params.output_dir}
            rm {output.output_script}
            cp {params.modified_script} {output.output_script}
        """
