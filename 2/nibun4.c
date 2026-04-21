/***************************************************/
/* 2分法のプログラム nibun.c */
/***************************************************/
#include <stdlib.h>
#include <stdio.h>
/*** 関数の定義 ***/
#define FNF(x) (x * x * x * x - 3 * x - 1)
#define EPS 0.000001
#define MAX_ITER 1000000000

typedef struct
{
    double a;
    double b;
    int valid;
    int count;
    double root;
} Result;

static int bisection(double a, double b, int *count, double *root)
{
    double c;
    double prev_width;
    double width;
    int k = 0;
    int estimated_iter = 0;
    const char spinner[] = "|/-\\";
    int spinner_index = 0;

    if (!(a < b) || FNF(a) * FNF(b) >= 0)
    {
        return 0;
    }

    width = b - a;
    while (width > EPS && estimated_iter < MAX_ITER)
    {
        width = width / 2.0;
        estimated_iter = estimated_iter + 1;
    }

    prev_width = b - a;
    while (prev_width >= EPS)
    {
        double next_a;
        double next_b;

        k = k + 1;
        if (k > MAX_ITER)
        {
            fprintf(stderr, "\n警告: 最大反復回数 %d に達したため打ち切りました。\n", MAX_ITER);
            return 0;
        }

        c = (a + b) / 2.0;
        if (FNF(a) * FNF(c) > 0)
        {
            next_a = c;
            next_b = b;
        }
        else
        {
            next_a = a;
            next_b = c;
        }

        if (c == a || c == b)
        {
            fprintf(stderr, "\n警告: 浮動小数点精度の限界で区間更新できなくなったため打ち切りました。\n");
            return 0;
        }

        a = next_a;
        b = next_b;

        prev_width = b - a;
        if (k <= 20 || k % 100 == 0)
        {
            fprintf(stderr, "\r[%c] 計算中... %d回目 (推定%d回) 区間幅=%.10g", spinner[spinner_index], k, estimated_iter, prev_width);
            fflush(stderr);
            spinner_index = (spinner_index + 1) % 4;
        }
    }

    fprintf(stderr, "\r[完了] 計算中... %d回目 (推定%d回) 区間幅=%.10g\n", k, estimated_iter, prev_width);

    *count = k;
    *root = (a + b) / 2.0;
    return 1;
}

int main(void)
{
    char line[256];
    double a, b, root;
    int count;
    Result *results = NULL;
    size_t size = 0;
    size_t capacity = 0;
    size_t i;

    printf("a,b を入力してください (終了: q)\n");

    while (1)
    {
        Result r;

        printf("a,b = ");
        if (fgets(line, sizeof(line), stdin) == NULL)
        {
            break;
        }

        if (line[0] == 'q' || line[0] == 'Q')
        {
            break;
        }

        if (sscanf(line, "%lf,%lf", &a, &b) != 2)
        {
            fprintf(stderr, "入力形式エラー: a,b の形式で入力してください。\n");
            continue;
        }

        if (bisection(a, b, &count, &root))
        {
            r.a = a;
            r.b = b;
            r.valid = 1;
            r.count = count;
            r.root = root;
        }
        else
        {
            r.a = a;
            r.b = b;
            r.valid = 0;
            r.count = 0;
            r.root = 0.0;
        }

        if (size == capacity)
        {
            size_t new_capacity = (capacity == 0) ? 8 : capacity * 2;
            Result *tmp = (Result *)realloc(results, new_capacity * sizeof(Result));
            if (tmp == NULL)
            {
                fprintf(stderr, "メモリ確保に失敗しました。\n");
                free(results);
                return 1;
            }
            results = tmp;
            capacity = new_capacity;
        }

        results[size] = r;
        size++;
    }

    printf("a,b,計算回数,解\n");
    for (i = 0; i < size; i++)
    {
        if (results[i].valid)
        {
            printf("%.10g,%.10g,%d,%.6f\n", results[i].a, results[i].b, results[i].count, results[i].root);
        }
        else
        {
            printf("%.10g,%.10g,invalid,invalid\n", results[i].a, results[i].b);
        }
    }

    free(results);

    return 0;
}