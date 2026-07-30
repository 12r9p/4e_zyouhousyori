#include <math.h>
#include <stdio.h>

#define N 3

static int solve_gaussian(double a[N][N + 1], double x[N])
{
    int i, j, k, pivot;

    for (i = 0; i < N; i++)
    {
        pivot = i;
        for (j = i + 1; j < N; j++)
        {
            if (fabs(a[j][i]) > fabs(a[pivot][i]))
            {
                pivot = j;
            }
        }

        if (fabs(a[pivot][i]) < 1e-12)
        {
            return 0;
        }

        if (pivot != i)
        {
            for (k = i; k <= N; k++)
            {
                double tmp = a[i][k];
                a[i][k] = a[pivot][k];
                a[pivot][k] = tmp;
            }
        }

        for (j = i + 1; j < N; j++)
        {
            double factor = a[j][i] / a[i][i];
            for (k = i; k <= N; k++)
            {
                a[j][k] -= factor * a[i][k];
            }
        }
    }

    for (i = N - 1; i >= 0; i--)
    {
        double sum = a[i][N];
        for (j = i + 1; j < N; j++)
        {
            sum -= a[i][j] * x[j];
        }
        x[i] = sum / a[i][i];
    }

    return 1;
}

int main(void)
{
    /*
     * 2x + 3y - z = 5
     *  x - 2y - z = -7
     *      - 5z   = -15
     */
    double a[N][N + 1] = {
        {2.0, 3.0, -1.0, 5.0},
        {1.0, -2.0, -1.0, -7.0},
        {0.0, 0.0, -5.0, -15.0},
    };
    double x[N];
    int i;

    if (!solve_gaussian(a, x))
    {
        printf("no unique solution\n");
        return 1;
    }

    for (i = 0; i < N; i++)
    {
        printf("x(%d)=%.6f\n", i + 1, x[i]);
    }

    return 0;
}
