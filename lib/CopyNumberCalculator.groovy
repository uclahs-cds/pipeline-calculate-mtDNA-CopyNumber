/**
*   Wrapping calculator into a class to be able to use it within other classes/scripts
*/
class CopyNumberCalculator {
    /**
    *   Calculate mitochondrial copy number assuming a ploidy of 2
    */
    public static double calculate_mitochondrial_copynumber(double autosomal_average, double mitochondrial_average, double autosomal_ploidy=2) {
        return autosomal_ploidy * (mitochondrial_average / autosomal_average);
    }
}
