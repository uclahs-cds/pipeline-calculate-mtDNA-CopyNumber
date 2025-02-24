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


/**
*   Calculate mitochondrial copy number assuming a ploidy of 2
*/
double calculate_mitochondrial_copynumber(double autosomal_average, double mitochondrial_average, double ploidy=2) {
    return ploidy * (mitochondrial_average / autosomal_average);
}

interface CoverageHandler {
    double get_autosomal_average_coverage();

    double get_mitochondrial_average_coverage();
}

class QualimapCoverage implements CoverageHandler {

    private String genome_stats_file;
    private double autosomal_average_coverage;
    private double mitochondrial_average_coverage;
    private Map data;

    QualimapCoverage(String stats_file) {
        genome_stats_file = stats_file;
    }

    double get_autosomal_average_coverage() {
        return 1.0;
    }

    double get_mitochondrial_average_coverage() {
        return 1.0;
    }
}

Map coverage_parsers = [
    'Qualimap': QualimapCoverage
]

workflow {
    System.out.println(params);

    Map calculated_copynumbers = [:];

    params.input.coverage.each { coverage_source, coverage_data ->
        def coverage_parser = coverage_parsers[coverage_source](coverage_data)
        System.out.println(calculate_mitochondrial_copynumber(coverage_parser.get_autosomal_average_coverage(), coverage_parser.get_mitochondrial_average_coverage()))
    }
}
