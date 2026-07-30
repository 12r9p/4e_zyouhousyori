#include <math.h>
#include <stdio.h>

#define N 10

static void swap_rows(double a[][N + 1], int i, int n)
{
    int j, k = i;
    double tmp;

    for (j = i + 1; j <= n; j++) {
        if (fabs(a[k][i]) < fabs(a[j][i])) {
            k = j;
        }
    }
    for (j = 1; j <= n + 1; j++) {
        tmp = a[k][j];
        a[k][j] = a[i][j];
        a[i][j] = tmp;
    }
}

int main(void)
{
    int i, j, k, n = 4;
    double p, q, s;
    double x[N] = {0};
    double a[N][N + 1] = {
        {0},
        {0, 2, 8, 2, -3, 2},
        {0, 4, 6, -2, -1, 1},
        {0, 2, -4, -2, -1, 3},
        {0, 1, -5, 2, 1, -2},
    };

    for (i = 1; i <= n; i++) {
        swap_rows(a, i, n);
        p = a[i][i];
        if (fabs(p) < 1.0e-6) {
            printf("一意解を持ちません。\n");
            return 1;
        }
        for (j = i; j <= n + 1; j++) {
            a[i][j] /= p;
        }
        for (k = i + 1; k <= n; k++) {
            q = a[k][i];
            for (j = i; j <= n + 1; j++) {
                a[k][j] -= a[i][j] * q;
            }
        }
    }

    for (i = n; i >= 1; i--) {
        s = 0.0;
        for (j = i + 1; j <= n; j++) {
            s += a[i][j] * x[j];
        }
        x[i] = a[i][n + 1] - s;
    }

    printf("ガウスの消去法による連立方程式の解\n\n");
    for (i = 1; i <= n; i++) {
        printf("x( %d ) = %10.6f\n", i, x[i]);
    }
    return 0;
}
