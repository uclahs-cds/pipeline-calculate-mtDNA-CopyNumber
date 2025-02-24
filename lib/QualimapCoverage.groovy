class QualimapCoverage implements CoverageHandler {

    private String genome_stats_file;
    private double autosomal_average_coverage = 0;
    private double mitochondrial_average_coverage = 0;
    private Map autosomal_data = [:];

    private void load_stats() {
        File f = new File(this.genome_stats_file);
        def line;
        Boolean coverage_reached = false;
        f.withReader { reader ->
            while ((line = reader.readLine()) != null) {
                line = line.stripIndent();
                if (line.contains('> Coverage per contig')) {
                    coverage_reached = true;
                    continue;
                }

                if (!coverage_reached) {
                    continue;
                }

                if (line ==~ /chr[0-9]+\t.*/) {
                    def line_parts = line.split("\t");
                    this.autosomal_data[line_parts[0]] = [
                        'bases': (line_parts[1] as double),
                        'cov': (line_parts[3] as double)
                    ]
                }

                if (line ==~ /chrM\t.*/) {
                    this.mitochondrial_average_coverage = line.split("\t")[3] as double;
                }
            }
        }

        this.calculate_autosomal_coverage();
    }

    private void calculate_autosomal_coverage() {
        double running_average = 0;
        Integer count = 0;
        this.autosomal_data.each { chr, chr_data ->
            running_average = AverageUpdater.update_average(running_average, count, chr_data['cov'], chr_data['bases']);
            count = count + chr_data['bases'];
        }

        this.autosomal_average_coverage = running_average;
    }

    QualimapCoverage(String stats_file) {
        genome_stats_file = stats_file;
        this.load_stats();
    }

    double get_autosomal_average_coverage() {
        return this.autosomal_average_coverage;
    }

    double get_mitochondrial_average_coverage() {
        return this.mitochondrial_average_coverage;
    }
}
