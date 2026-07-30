/***********************************************/
/*            ’·•ûŒ`Œ^           tyouhou.c     */
/***********************************************/
#include <stdio.h>
#include <math.h>
#define  FNF(x)  exp(-x*x)
#define  PI      3.141592653589793
int main(void) 
{   int     i;
    double  sekibun, a, h, n, s; 
    char    zz;
    printf("\nf(x) = exp(-x*x)@‚ÌÏ•ª\n\n");
    printf("Ï•ª”ÍˆÍ [ -a , a ] ‚Ì a = ");
    scanf("%lf%c",&a,&zz);
    h = 0.1;    n = a / h;    s = 0.0;
    for(i=-n; i<=n-1; i++) {
        s += FNF(h*i) * h;
    }
    sekibun = s / sqrt(PI);
    printf("Ï•ª’l = %10.6lf\n",sekibun);
    return 0; 
}
