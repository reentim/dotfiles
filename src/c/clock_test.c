#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

// Helper function to calculate standard deviation
double calculate_stdev(double *diffs, int n) {
	double sum = 0.0;
	double mean;
	double stdev = 0.0;

	for (int i = 0; i < n; i++) {
		sum += diffs[i];
	}

	mean = sum / n;

	for (int i = 0; i < n; i++) {
		stdev += pow(diffs[i] - mean, 2);
	}

	return sqrt(stdev / n);
}

int main() {
	struct timespec start, end;
	double *diffs;
	double total_diff = 0.0;
	int trials = 1000;
	int overhead_trials = 5;

	diffs = malloc(trials * sizeof(double));

	// Back-to-back clock read diffs (1000 trials)
	printf("Testing back-to-back clock reads (%d trials):\n", trials);
	for (int i = 0; i < trials; i++) {
		clock_gettime(CLOCK_MONOTONIC_RAW, &start);
		clock_gettime(CLOCK_MONOTONIC_RAW, &end);

		// Calculate time diff in seconds
		diffs[i] = (end.tv_sec - start.tv_sec) * 1e9 + (end.tv_nsec - start.tv_nsec);
		diffs[i] /= 1e6; // Convert to milliseconds
		total_diff += diffs[i];
	}

	double min_diff = diffs[0];
	double max_diff = diffs[0];
	for (int i = 1; i < trials; i++) {
		if (diffs[i] < min_diff) min_diff = diffs[i];
		if (diffs[i] > max_diff) max_diff = diffs[i];
	}

	double avg_diff = total_diff / trials;
	double mdev = calculate_stdev(diffs, trials);

	printf("  %d loops, time %.3f ms\n", trials, total_diff);
	printf("  min/avg/max/mdev = %.3f/%.3f/%.3f/%.3f ms\n", min_diff, avg_diff, max_diff, mdev);

	// Testing loop overhead (5 trials)
	printf("Testing loop overhead (%d trials):\n", overhead_trials);
	double loop_overhead[overhead_trials];
	for (int i = 0; i < overhead_trials; i++) {
		clock_gettime(CLOCK_MONOTONIC_RAW, &start);
		clock_gettime(CLOCK_MONOTONIC_RAW, &end);
		loop_overhead[i] = (end.tv_sec - start.tv_sec) * 1e9 + (end.tv_nsec - start.tv_nsec);
		loop_overhead[i] /= 1e6; // Convert to milliseconds
	}

	double loop_avg = 0.0;
	for (int i = 0; i < overhead_trials; i++) {
		loop_avg += loop_overhead[i];
	}

	loop_avg /= overhead_trials;
	double loop_mdev = calculate_stdev(loop_overhead, overhead_trials);

	printf("  %d loops, time %.3f ms\n", overhead_trials, loop_avg);
	printf("  Loop overhead min/avg/max/mdev = %.3f/%.3f/%.3f/%.3f ms\n", loop_overhead[0], loop_avg, loop_overhead[overhead_trials-1], loop_mdev);

	free(diffs);
	return 0;
}

