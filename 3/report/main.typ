#import "@preview/js:0.1.3": *
#show: js.with(
  lang: "ja",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont-cjk: "Harano Aji Gothic"
)


#set page(paper: "a4", numbering: "1")
#set text(lang: "ja", region: "JP")

#let report_title = "情報処理II 第3回レポート"
#let subject = "4E 情報処理II"
#let assignment = "ニュートン法"
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

#let csv-table(path, columns) = {
  let rows = read(path).trim().split("\n").map(line => line.split(","))
  let header = rows.at(0)
  let body = rows.slice(1)
  let body-cells = body.map(row => row.map(cell => [#cell])).flatten()

  table(
    columns: columns,
    inset: 6pt,
    stroke: 0.6pt,
    ..header.map(cell => [#cell]),
    ..body-cells,
  )
}

= 課題3-1

教科書 p.7 の条件に合わせて, 初期値 $x_1=2$ で実行した。
方程式は $f(x)=x^3-3x^2+9x-8$。


使用ソースコードURL: https://github.com/12r9p/4e_zyouhousyori/blob/main/3/newton1.c

#csv-table("q1.csv", (1fr, 1fr, 1fr, 1fr, 1fr))

= 課題3-2

初期値を変更し, 収束時の計算回数と収束値を比較した。

使用ソースコードURL: https://github.com/12r9p/4e_zyouhousyori/blob/main/3/newton1.c

#csv-table("q2.csv", (1fr, 1fr, 1fr, 1fr, 1fr))

= 課題3-3

収束条件を変更し, 計算回数と収束値の違いを確認した。


使用ソースコードURL: https://github.com/12r9p/4e_zyouhousyori/blob/main/3/newton1.c

#csv-table("q3.csv", (1fr, 1fr, 1fr, 1fr, 1fr))

= 課題3-4

方程式を $x^4-3x+1=0$ に変更し, 初期値 0.9 と 2 で実行した。


使用ソースコードURL: https://github.com/12r9p/4e_zyouhousyori/blob/main/3/newton2.c

#csv-table("q4.csv", (1fr, 1fr, 1fr, 1fr, 1fr))

#pagebreak()

= 課題3-5

前回の2分法と今回のニュートン法を比較すると, 次の特徴がある。

- 収束速度: 今回の結果ではニュートン法は 4〜14 回程度で収束し, 前回の2分法(20回以上が多い)より少ない反復で解に到達した。
- 初期値・初期条件への依存: 2分法は区間 $[a,b]$ で符号変化があれば収束しやすく, 安定性が高い。一方ニュートン法は初期値 $x_0$ の選び方で収束先が変わったり, 条件によっては収束しない場合がある。

以上より, 確実に解を求めたい場合は2分法, ある程度よい初期値を与えられる場合はニュートン法が有利であると考えられる。