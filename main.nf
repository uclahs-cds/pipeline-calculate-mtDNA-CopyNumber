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
    Map calculated_copynumbers = [:];

    params.input.coverage.each { coverage_source, coverage_data ->
        def parser;

        // TO-DO: this block can be updated to be a bit more robust but leaving it as a simple conditional for now
        if ('Qualimap' == coverage_source) {
            parser = new QualimapCoverage(coverage_data);
        }

        calculated_copynumbers[coverage_source] = CopyNumberCalculator.calculate_mitochondrial_copynumber(parser.get_autosomal_average_coverage(), parser.get_mitochondrial_average_coverage());
    }

    File output_dir = new File("${params.output_dir_base}/${workflow.manifest.name}-${workflow.manifest.version}/output");
    if (!output_dir.exists()) {
        output_dir.mkdirs();
    }
    File output_file = new File("${params.output_dir_base}/${workflow.manifest.name}-${workflow.manifest.version}/output/mtDNA-copynumbers.txt");

    output_file.append("CoverageSource\tmtDNACopyNumber\n");

    calculated_copynumbers.each { coverage_source, copynumber ->
        output_file.append("${coverage_source}\t${copynumber}\n");
    }
}
