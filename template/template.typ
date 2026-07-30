#import "@preview/js:0.1.3": *
#show: js.with(
  lang: "ja",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont-cjk: "Harano Aji Gothic"
)


#set page(paper: "a4", numbering: "1")
#set text(lang: "ja", region: "JP")

#let report_title = "情報処理II 第回レポート"
#let subject = "4E 情報処理II"
#let assignment = ""
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