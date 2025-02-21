#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Log info here
log.info """\
        =======================================
          PIPELINE-CALCULATE-MTDNA-COPYNUMBER
        =======================================
        Boutros Lab

        Current Configuration:
        - pipeline:
            name: ${workflow.manifest.name}
            version: ${workflow.manifest.version}

        - input:
            input Qualimap coverage: ${params.input.coverage.getOrDefault("Qualimap", "None")}

        - output:
            output: ${params.output_dir_base}

        ------------------------------------
        Starting workflow...
        ------------------------------------
        """
        .stripIndent()

workflow {
    System.out.println(params)
}
