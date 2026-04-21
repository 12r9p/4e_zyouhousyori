#import "@preview/js:0.1.3": *
#show: js.with()

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

= 課題概要

- 教科書 pp.2-6 を読み, 2分法とプログラム `nibun.c` の動作を理解する。
- 問1〜問4の条件で実行し, 収束時の計算回数と解(収束値)を比較する。

= 実行環境

- OS:
- コンパイラ:
- コンパイルコマンド:
- 実行コマンド:

= 問1 2分法(1)

教科書 pp.2-3 と同じ条件で実行し, 収束値が約 1.165 となることを確認する。

- 方程式: $f(x) = x^3 - 3x^2 + 9x - 8$
- 第1区間: $[a, b] = [1, 2]$

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [項目], [結果],
  [収束時の計算回数], [　],
  [解(収束値)], [　],
)

実行ログ(必要に応じて貼り付け):

考察:

= 問2 2分法(2)

第1区間を問1と異なる値に変更し, 同様に収束するか確認する。

- 使用した第1区間: [a, b] = [      ,      ]

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [$a$], [$b$], [収束時の計算回数], [解(収束値)],
  [　], [　], [　], [　],
)

実行ログ(必要に応じて貼り付け):

考察:

= 問3 2分法(3)

`nibun.c` の収束条件(33行目)を変更し, 実行結果の変化を確認する。

#table(
  columns: (2fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [収束条件], [$a$], [$b$], [収束時の計算回数 / 解(収束値)],
  [例: `fabs(f(c)) < 1e-6`], [　], [　], [　],
  [変更後条件], [　], [　], [　],
)

実行ログ(必要に応じて貼り付け):

考察:

= 問4 2分法(4)

教科書 p.9 演習問題1の 1.1(1) の方程式に対しても解を求められるか確認する。

- 方程式: $f(x) = x^3 - 3x + 1$
- 変更箇所: `#define FNF(x) (x*x*x - 3*x + 1)`
- 使用した第1区間: [a, b] = [      ,      ]

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [$a$], [$b$], [収束時の計算回数], [解(収束値)],
  [　], [　], [　], [　],
)

実行ログ(必要に応じて貼り付け):

考察:

= まとめ

- 問1〜問4で確認した収束の違い:
- 初期区間と収束条件が結果に与える影響:
- 今後の改善点: