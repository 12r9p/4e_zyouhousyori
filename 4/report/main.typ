#import "@preview/js:0.1.3": *
#show: js.with(
  lang: "ja",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont-cjk: "Harano Aji Gothic"
)


#set page(paper: "a4", numbering: "1")
#set text(lang: "ja", region: "JP")
#set heading(numbering: none)

#let report_title = "情報処理II 第4回レポート"
#let subject = "4E 情報処理II"
#let assignment = "連立1次方程式"
#let student_id = "学籍番号: 2023091"
#let student_name = "氏名: 佐藤匠"

#align(center + horizon)[
  #text(size: 24pt, weight: "bold")[#report_title]
  #v(1.2em)
  #text(size: 14pt)[#subject]
  #text(size: 14pt)[課題: #assignment]
  #v(2em)
  #text(size: 12pt)[#student_id]
  #v(1em)
  #text(size: 12pt)[#student_name]
  #v(1em)
  #datetime.today().display("[year]年[month]月[day]日")
]

#pagebreak()


= 使用プログラム

教科書 pp.14-15 の上三角型連立方程式解法プログラム `ue3kaku.c` を用いて計算した。


= 課題 4-1 上三角型連立方程式（1）

== 問題

教科書 p.12 の連立方程式を次のように与えた。

#align(center)[
  $
    cases(
      2x_1 - x_2 - 3x_3 = 1,
      2x_2 + 3x_3 + 7x_4 = 0,
      x_3 - 9x_4 = 6,
      5x_4 = -3,
    )
  $
]

== 出力画面

#raw(
  "上三角型の連立方程式の解\n\nx( 1 ) =   2.000000\nx( 2 ) =   1.200000\nx( 3 ) =   0.600000\nx( 4 ) =  -0.600000",
  block: true,
)

== 確認

出力より、
$x_1 = 2.000000$, $x_2 = 1.200000$, $x_3 = 0.600000$, $x_4 = -0.600000$
を得た。

= 課題 4-2 上三角型連立方程式（2）

== 問題

課題の連立方程式を次のように与えた。

#align(center)[
  $
    cases(
      2x_1 + 3x_2 - x_3 = 5,
      x_2 - 2x_3 = -7,
      -5x_3 = -15,
    )
  $
]


== 出力画面

#raw(
  "上三角型の連立方程式の解\n\nx( 1 ) =   5.500000\nx( 2 ) =  -1.000000\nx( 3 ) =   3.000000",
  block: true,
)

== 手計算

上三角型の逆進代入で手計算する。

まず 3 行目より
$-5x_3 = -15$ なので $x_3 = 3$。

次に 2 行目より
$x_2 - 2x_3 = -7$ へ $x_3 = 3$ を代入して
$x_2 - 6 = -7$、したがって $x_2 = -1$。

最後に 1 行目より
$2x_1 + 3x_2 - x_3 = 5$ へ
$x_2 = -1$, $x_3 = 3$ を代入して
$2x_1 - 3 - 3 = 5$、よって $2x_1 = 11$。

したがって
$x_1 = 11/2 = 5.5$。

== 手計算とプログラム出力の一致

手計算の結果
$x_1 = 5.5$, $x_2 = -1$, $x_3 = 3$
は、出力画面の
$x(1)=5.500000$, $x(2)=-1.000000$, $x(3)=3.000000$
と一致した。


