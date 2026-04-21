/***************************************************/
/* ニュートン法のプログラム newton2.c            */
/* f(x) = x^4 - 3x + 1                            */
/***************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define FNF(x) ((x) * (x) * (x) * (x) - 3.0 * (x) + 1.0)
#define DNF(x) (4.0 * (x) * (x) * (x) - 3.0)
#define MAX_ITER 100000

typedef struct
{
    double eps;
    double x0;
    int valid;
    int count;
    double root;
    double residual;
} Result;

static int newton(double eps, double x0, int *count, double *root, double *residual)
{
    double x = x0;
    int k;

    if (eps <= 0.0)
    {
        return 0;
    }

    for (k = 1; k <= MAX_ITER; k++)
    {
        double fx = FNF(x);
        double dfx = DNF(x);
        double next;

        if (fabs(dfx) < 1e-14)
        {
            return 0;
        }

        next = x - fx / dfx;

        if (fabs(next - x) < eps)
        {
            *count = k;
            *root = next;
            *residual = fabs(FNF(next));
            return 1;
        }

        x = next;
    }

    return 0;
}

int main(void)
{
    char line[256];
    double eps, x0, root, residual;
    int count;
    Result *results = NULL;
    size_t size = 0;
    size_t capacity = 0;
    size_t i;

    printf("eps,x0 を入力してください (終了: q)\n");

    while (1)
    {
        Result r;

        if (fgets(line, sizeof(line), stdin) == NULL)
        {
            break;
        }

        if (line[0] == 'q' || line[0] == 'Q')
        {
            break;
        }

        if (sscanf(line, "%lf,%lf", &eps, &x0) != 2)
        {
            continue;
        }

        r.eps = eps;
        r.x0 = x0;

        if (newton(eps, x0, &count, &root, &residual))
        {
            r.valid = 1;
            r.count = count;
            r.root = root;
            r.residual = residual;
        }
        else
        {
            r.valid = 0;
            r.count = 0;
            r.root = 0.0;
            r.residual = 0.0;
        }

        if (size == capacity)
        {
            size_t new_capacity = (capacity == 0) ? 8 : capacity * 2;
            Result *tmp = (Result *)realloc(results, new_capacity * sizeof(Result));
            if (tmp == NULL)
            {
                free(results);
                return 1;
            }
            results = tmp;
            capacity = new_capacity;
        }

        results[size] = r;
        size++;
    }

    printf("eps,x0,計算回数,解,|f(x)|\n");
    for (i = 0; i < size; i++)
    {
        if (results[i].valid)
        {
            printf("%.10g,%.10g,%d,%.8f,%.3e\n", results[i].eps, results[i].x0, results[i].count, results[i].root, results[i].residual);
        }
        else
        {
            printf("%.10g,%.10g,invalid,invalid,invalid\n", results[i].eps, results[i].x0);
        }
    }

    free(results);
    return 0;
}
