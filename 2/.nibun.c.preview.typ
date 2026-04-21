/***************************************************/
/* 2分法のプログラム nibun.c */
/***************************************************/
#include <stdio.h>
/*** 関数の定義 ***/
#define FNF(x) (x*x*x - 3*x*x + 9*x - 8)
int main(void){
     double a, b, c;
int k;
char z, zz;
while( 1 ) {
printf("f(a)*f(b)<0 となる a , b を");
printf("入力して下さい。\n\n");
printf("第1区間 [a,b] の a=");
scanf("%lf%c",&a,&zz);
printf("第1区間 [a,b] の b=");
scanf("%lf%c",&b,&zz);
printf("\n 正しく入力しましたか。(y/n)");
scanf("%c%c",&z,&zz);
if(z == 'n') continue;
if((z == 'y')&&(a < b)&&(FNF(a) * FNF(b) < 0))

break;

else {
printf("\n a>b か f(a)*f(b)>=0 になります。\n");
printf("データを入れなおして下さい。\n");
printf("リターンキーを押して下さい。\n");
scanf("%c",&z); continue;
}
}
k = 0;
printf("回数 左端 A 右端 B 区間幅 B-A\n");
/*** 収束するまで繰り返す ***/
while( b - a >= 0.000001) {
k = k + 1;
printf("%4d %8.5lf %8.5lf %8.5lf\n",k,a,b,b-a);
/* 点 a,b の中点を求め、a,b の座標を更新する */
c = ( a + b ) / 2.0;
if( FNF(a) * FNF(c) > 0 ) a = c;
else b = c;
if((k % 10) == 0) {
printf("\n 計算過程を表示しています。\n");
printf("表示を継続しますか? (y/n): ");
scanf("%c%c",&z,&zz);
if(z == 'n') {
printf("\n 表示を終わります。\n"); break;
} else if(z == 'y')
printf("回数 左端 A 右端 B 区間幅 B-A\n");
else { z = 'n'; break; }

}
}
if(z != 'n') {
printf("\n %3d 回目で収束しました。\n",k);
printf("\n 収束値 = %10.6lf\n", (a+b)/2.0);
}
return 0;
}