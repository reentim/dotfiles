#include <stdio.h>
#include <time.h>

int main() {
    struct timespec time;

    clock_gettime(CLOCK_MONOTONIC, &time);
	double now = time.tv_sec + time.tv_nsec*1e-9;
	printf("%f\n", now);
}
