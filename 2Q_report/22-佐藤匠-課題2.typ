#set page(
  paper: "a4",
  margin: (x: 22mm, y: 20mm),
  numbering: "1",
)
#set text(lang: "ja", region: "JP", font: "Harano Aji Mincho", size: 10.5pt)
#set par(justify: true, leading: 0.75em)
#set heading(numbering: none)
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  set text(size: 16pt, weight: "bold")
  block(above: 1.5em, below: 1.5em)[#it.body]
}
#show heading.where(level: 2): it => {
  set text(size: 12pt, weight: "bold")
  block(above: 1.8em, below: 1.2em)[#it.body]
}

#let terminal(body) = block(
  width: 100%,
  fill: rgb("#f3f4f6"),
  stroke: 0.6pt + rgb("#777777"),
  radius: 3pt,
  inset: 8pt,
)[#set text(font: "DejaVu Sans Mono", size: 8.3pt); #raw(body)]

#let change(before, after) = table(
  columns: (1fr, 1fr),
  inset: 6pt,
  stroke: 0.5pt,
  fill: (_, row) => if row == 0 { rgb("#e8eef8") },
  [変更前], [変更後],
  [#raw(before, lang: "c")], [#raw(after, lang: "c")],
)

#let csv-table(path, columns) = {
  let rows = read(path).trim().split("\n").map(line => line.split(","))
  let header = rows.at(0)
  let body = rows.slice(1)
  let body-cells = body.map(row => row.map(cell => [#cell])).flatten()

  table(
    columns: columns,
    inset: 5pt,
    stroke: 0.5pt,
    fill: (_, row) => if row == 0 { rgb("#e8eef8") },
    ..header.map(cell => [#cell]),
    ..body-cells,
  )
}

#align(center + horizon)[
  #text(size: 24pt, weight: "bold")[4E 情報処理II レポート課題2]
  #v(1.5em)
  #text(size: 14pt)[数値計算法（補間・最小二乗法・数値積分・微分方程式）]
  #v(4em)
  #text(size: 12pt)[学籍番号: 2023091]
  #v(1em)
  #text(size: 12pt)[出席番号: 22]
  #v(1em)
  #text(size: 12pt)[氏名: 佐藤 匠]
  #v(3em)
  #text(size: 11pt)[提出日: 2026年7月31日]
]

#pagebreak()

= 第7回演習 課題7-3 スプライン関数

== 1次係数 $C_j$ の手計算による導出過程
教科書 p.66 例題4.1 のデータ点および境界条件は以下の通りである。
- データ点：$(x_0, y_0) = (0.0, 1.0)$，$(x_1, y_1) = (1.0, 3.0)$，$(x_2, y_2) = (2.0, 2.0)$
- 境界条件（端点での1次導関数）：$C_1 = 5.0$，$C_3 = 3.0$ （$n=2$ のため $C_{n+1} = C_3$）

各区間の幅 $h_j = x_j - x_{j-1}$ を計算すると、

$ h_1 = 1.0 - 0.0 = 1.0, quad h_2 = 2.0 - 1.0 = 1.0 $

各区間の平均変化率 $u_j = (y_j - y_{j-1}) / h_j$ を計算すると、

$ u_1 = (3.0 - 1.0) / 1.0 = 2.0, quad u_2 = (2.0 - 3.0) / 1.0 = -1.0 $

1次係数 $c_j$ に関する連立方程式のうち、つなぎ目である節点 $x_1$ ($j=2$) における方程式は次式で与えられる。

$ h_2 c_1 + 2(h_1 + h_2) c_2 + h_1 c_3 = 3(h_2 u_1 + h_1 u_2) $

ここに具体的な数値を代入すると、

$ 1.0 times 5.0 + 2(1.0 + 1.0) c_2 + 1.0 times 3.0 = 3(1.0 times 2.0 + 1.0 times (-1.0)) $

$ 5.0 + 4.0 c_2 + 3.0 = 3(2.0 - 1.0) $

$ 8.0 + 4.0 c_2 = 3.0 $

$ 4.0 c_2 = -5.0 quad arrow.r quad c_2 = -1.25 $

したがって、求める1次係数 $C_j$ は次の通りとなる。

$ C_1 = 5.0, quad C_2 = -1.25, quad C_3 = 3.0 $

これはプログラムの出力結果と完全に一致する。

さらに、2次係数 $B_j$ および3次係数 $A_j$ を漸化式から手計算で求める。

$ B_1 = (3u_1 - 2C_1 - C_2) / h_1 = (3 times 2.0 - 2 times 5.0 - (-1.25)) / 1.0 = 6.0 - 10.0 + 1.25 = -2.75 $

$ B_2 = - (3u_1 - C_1 - 2C_2) / h_1 = - (3 times 2.0 - 5.0 - 2 times (-1.25)) / 1.0 = - (6.0 - 5.0 + 2.5) = -3.5 $

$ A_1 = (B_2 - B_1) / (3 h_1) = (-3.5 - (-2.75)) / (3 times 1.0) = -0.75 / 3 = -0.25 $

$ A_2 = (u_2 - h_2 B_2 - C_2) / (h_2^2) = (-1.0 - 1.0 times (-3.5) - (-1.25)) / (1.0^2) = -1.0 + 3.5 + 1.25 = 3.75 $

以上より、決定された各区間の3次スプライン関数 $S_j (x)$ は以下の通りとなる。

$ S_1(x) = -0.25 x^3 - 2.75 x^2 + 5.0 x + 1.0 quad (0.0 <= x <= 1.0) $

$ S_2(x) = 3.75(x-1.0)^3 - 3.5(x-1.0)^2 - 1.25(x-1.0) + 3.0 quad (1.0 <= x <= 2.0) $



#pagebreak()

= 第8回演習 課題8-2 最小二乗法

== 目的とプログラムの動作確認
最小二乗法を用いて、測定データ点群に対して残差の二乗和が最小となるような近似関数 $y = a f(x) + b g(x)$ を決定する。
プログラム `minjijo.c` をコンパイルし、教科書記載の2つの例題に対して実行し、正しく最小二乗近似が行われることを確認した。

== 課題8-2（例題4.2）の実行結果
教科書 p.76 の例題 4.2 のデータ点（7点）に対し、近似関数を $y = a/x + b x$ と仮定して最小二乗近似を行った。
プログラムの実行時のコンソール出力を以下に示す。

#terminal("基本関数 f(x), g(x)を 1～4 の番号で選択してください
f(x)=[1:(x),2:(1/x),3:(e^x)]--> 2
g(x)=[1:(x),2:(1/x),3:(e^x),4(定数)]--> 1
データの個数は何個ですか。(1<n<10) n = 7

データ x の値は小から大の順に入力する。
X = 0.2
Y = 12.1
...
X = 10.0
Y = 4.3
正しく入力しましたか (y/n) y

求めた基本関数の係数の出力
 a = d[1] = 2.401050
 b = d[2] = 0.398093")

これにより、最小二乗近似関数は次式のように得られた。
$ y = 2.401050 / x + 0.398093 x $
出力された数表データを用いたグラフを図2に示す。

#align(center)[
  #image("plots/minjijo_plot.png", width: 60%)
  図2: 最小二乗近似曲線 ($y = 2.401/x + 0.398x$)
]

#pagebreak()

= 第9回演習 課題9-1 (数値積分)長方形近似(1)

== 被積分関数と積分区間の修正
積分 $I = integral_0^1 (1-x) e^(-x) d x$ を計算するように、プログラム `tyouhou.c` の被積分関数 `FNF(x)` と積分区間の初期設定を以下のように修正し、`tyouhou_mod.c` を作成した。

#change(
  "#define  FNF(x)  exp(-x*x)\n...\nprintf(\"\\n(x) = exp(-x*x) の積分\\n\\n\");\nprintf(\"積分範囲 [ -a , a ] の a = \");\nscanf(\"%lf%c\",&a,&zz);\nh = 0.1;    n = a / h;    s = 0.0;\nfor(i=-n; i<=n-1; i++) {\n    s += FNF(h*i) * h;\n}",
  "#define  FNF(x)  ((1.0 - (x)) * exp(-(x)))\n...\n// 積分範囲を [0.0, 1.0] に固定\na = 0.0;\nb = 1.0;\nh = 0.1;\nn = (b - a) / h;\ns = 0.0;\nfor(i=0; i<=n-1; i++) {\n    s += FNF(a + h * i) * h;\n}"
)

== 実行結果
修正したプログラムを実行した結果、近似積分値として以下を得た。

$ I_(r e c t) approx 0.419239 $

また、この積分の解析解 $I$ は、部分積分法（課題9-2）により次のように求められる。

$ I = integral_0^1 (1-x) e^(-x) d x = e^(-1) approx 0.367879 $

#pagebreak()

= 第9回演習 課題9-4 (数値積分)シンプソンの公式(2)

== 各分点における関数値の準備
刻み幅は $h = (2-1) / 10 = 0.1$ である。各分点 $x_i = 1.0 + 0.1 i$ ($i=0, 1, dots, 10$) における被積分関数 $f(x) = log(x)$ の値を予め計算しておく。

$ f(x_0) = f(1.0) = 0.000000 $

$ f(x_1) = f(1.1) approx 0.095310, quad f(x_2) = f(1.2) approx 0.182322 $

$ f(x_3) = f(1.3) approx 0.262364, quad f(x_4) = f(1.4) approx 0.336472 $

$ f(x_5) = f(1.5) approx 0.405465, quad f(x_6) = f(1.6) approx 0.470004 $

$ f(x_7) = f(1.7) approx 0.530628, quad f(x_8) = f(1.8) approx 0.587787 $

$ f(x_9) = f(1.9) approx 0.641854, quad f(x_10) = f(2.0) approx 0.693147 $


== シンプソンの公式による手計算 (課題9-4)
シンプソンの公式の近似式は次式で与えられる。

$ I_(s i m p) = h / 3 [ f(x_0) + 4 sum_(i: text("奇数")) f(x_i) + 2 sum_(i: text("偶数")) f(x_i) + f(x_(10)) ] $

奇数項および偶数項の和をそれぞれ計算する。

$ sum_(i=1,3,5,7,9) f(x_i) = 0.095310 + 0.262364 + 0.405465 + 0.530628 + 0.641854 = 1.935621 $

$ sum_(i=2,4,6,8) f(x_i) = 0.182322 + 0.336472 + 0.470004 + 0.587787 = 1.576585 $

これらを公式に代入する。

$ I_(s i m p) = 0.1 / 3 [ 0.000000 + 4 times 1.935621 + 2 times 1.576585 + 0.693147 ] $
$ = 0.1 / 3 [ 7.742484 + 3.153170 + 0.693147 ] = 0.1 / 3 [ 11.588801 ] approx 0.386293 $

== 解析解
本積分の解析解 $I$ は次のように求められる。

$ I = integral_1^2 log(x) d x = 2 log(2) - 1 approx 0.386294 $

#pagebreak()

= 第11回演習 課題11-1 オイラー法

== 目的とプログラムの作成
ルンゲ・クッタ2次公式のプログラム `rungekt2.c` を書き換えて、オイラー法で常微分方程式を解くプログラムを作成した。
元のプログラムからの変更箇所を以下に示す。

#change(
  "        k1 = h * fnf(x,y);\n        k2 = h * fnf(x+h,y+k1);\n        k  = (k1 + k2) / 2.0;\n        x  = x + h;\n        y  = y + k;",
  "        k  = h * fnf(x,y);\n        y  = y + k;\n        x  = x + h;"
)

== 実行結果と精度比較
対象とする常微分方程式は以下の通りである。

$ d y / (d x) = y - 12x + 3, quad y(0) = 1, quad h = 0.1 $

この微分方程式の真値（解析解）は次式で与えられる。

$ y(x) = 12x - 8e^x + 9 $



#align(center)[
  #grid(
    columns: (1.4fr, 1.6fr),
    gutter: 15pt,
    [
      #set text(size: 7.5pt)
      #csv-table("data/ode_output.csv", (0.8fr, 1.2fr, 1.2fr, 1.2fr))
      #v(-2pt)
      表2: 各数値解法と真値の比較
    ],
    [
      #v(30pt)
      #image("plots/ode_plot.png", width: 95%)
      #v(-2pt)
      図3: 数値解の比較グラフ
    ]
  )
]
