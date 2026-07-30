/***********************************************/
/*        長方形型 (修正版)      tyouhou_mod.c */
/***********************************************/
#include <stdio.h>
#include <math.h>
#define  FNF(x)  ((1.0 - (x)) * exp(-(x)))
int main(void) 
{   int     i, n;
    double  sekibun, a, b, h, s; 
    a = 0.0;
    b = 1.0;
    h = 0.1;
    n = (b - a) / h;
    s = 0.0;
    for(i=0; i<=n-1; i++) {
        s += FNF(a + h * i) * h;
    }
    sekibun = s;
    printf("積分値 = %10.6lf\n",sekibun);
    return 0; 
}
