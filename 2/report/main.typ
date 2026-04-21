#import "@preview/js:0.1.3": *
#import "@preview/codelst:2.0.2": *
#show: js.with(
  lang: "ja",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont-cjk: "Harano Aji Gothic"
)


#set page(paper: "a4", numbering: "1")
#set text(lang: "ja", region: "JP")

#let report_title = "情報処理II 第2回レポート"
#let subject = "4E 情報処理II"
#let assignment = "2分法"
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

= 問1 2分法(1)

教科書 pp.2-3 と同じ条件で実行し, 収束値が約 1.165 となることを確認する。

- 方程式: $f(x) = x^3 - 3x^2 + 9x - 8$
- 第1区間: $[a, b] = [1, 2]$

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [項目], [結果],
  [収束時の計算回数], [20],
  [解(収束値)], [1.165905],
)


= 問2 2分法(2)

第1区間を問1と異なる値に変更し, 同様に収束するか確認する。

#let q2_rows = read("2.csv").trim().split("\n").map(line => line.split(","))
#let q2_cells = q2_rows.map(row => (
  [#row.at(0)],
  [#row.at(1)],
  [#row.at(2)],
  [#row.at(3)],
)).flatten()

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [$a$], [$b$], [収束時の計算回数], [解(収束値)],
  ..q2_cells,
)


= 問3 2分法(3)

`nibun.c` の収束条件(33行目)を変更し, 実行結果の変化を確認する。

#let q3_rows = read("3.csv").trim().split("\n").map(line => line.split(","))
#let q3_cells = q3_rows.map(row => (
  [#row.at(0)],
  [#row.at(1)],
  [#row.at(2)],
  [#row.at(3)],
  [#row.at(4)],
)).flatten()
#table(
  columns: (2fr, 1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [収束条件], [$a$], [$b$], [収束時の計算回数], [解(収束値)],
  ..q3_cells,
)

= 問4 2分法(4)

教科書 p.9 演習問題1の 1.1(1) の方程式に対しても解を求められるか確認する。

- 方程式: $f(x) = x^4 - 3x + 1$

#let q4_rows = read("4.csv").trim().split("\n").map(line => line.split(","))
#let q4_cells = q4_rows.map(row => (
  [#row.at(0)],
  [#row.at(1)],
  [#row.at(2)],
  [#row.at(3)],
)).flatten()

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [$a$], [$b$], [収束時の計算回数], [解(収束値)],
  ..q4_cells,
)