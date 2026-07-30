#include <stdio.h>

int main(void)
{
    int j, k;
    const int n = 4;
    const double xx = 0.8;
    const double x[] = {0.5, 1.0, 1.5, 2.0};
    const double y[] = {0.3734, 0.5104, 0.4712, 0.3345};
    double result = 0.0;

    for (k = 0; k < n; k++) {
        double lk = 1.0;
        for (j = 0; j < n; j++) {
            if (j != k) {
                lk *= (xx - x[j]) / (x[k] - x[j]);
            }
        }
        printf("L%d(0.8) = %.6f\n", k, lk);
        result += lk * y[k];
    }
    printf("\nf(0.8) = %.7f\n", result);
    return 0;
}
