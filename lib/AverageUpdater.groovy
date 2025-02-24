/**
*   Wrapping updater into a class to be able to use it within other classes
*/
class AverageUpdater {
    /**
    *   Running average update function
    */
    public static double update_average(double current_average, Integer current_count, double update_average, Number update_count) {
        return (current_average / (1 + (update_count/current_count))) + (update_average / (1 + (current_count/update_count)));
    }
}
