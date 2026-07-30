# Typst の書き方メモ

他のレポートでも使い回せるように、Typst でよく使う数式の書き方、表の作り方、CSV を表に流し込む方法をまとめる。

## 数式の基本

- 行内数式は `$...$` で書く。
- 別行の数式は `#align(center)[ ... ]` や `#block[...]` を使う。
- 変数はそのまま、関数は `$f(x)$` のように書く。
- べき乗は `x^2`、添字は `x_1`。
- 分数は `frac(a, b)`、ルートは `sqrt(x)`。
- ギリシャ文字は `alpha`、`beta`、`lambda` などを使う。

### よく使う例

- `$f(x) = x^3 - 3x^2 + 9x - 8$`
- `$[a, b] = [1, 2]$`
- `$x_1 = 2$`
- `$|f(x)| < 10^(-6)$`
- `$x -> 1.165$`

### 体裁のコツ

- 数式中の記号はできるだけ Typst の数式モードで書く。
- 日本語の本文中に数式を混ぜるときも、数式部分だけ `$...$` にする。
- 文章で説明したいときは、数式のあとに短い補足を付ける。

## 表の基本

- 表は `table(...)` で作る。
- 列数を `columns:` で指定する。
- 見出し行を最初に置き、そのあとにデータを並べる。
- `inset` で余白、`stroke` で罫線の太さを調整できる。

### 最小例

```typst
#table(
  columns: (1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [項目], [値1], [値2],
  [A], [10], [20],
  [B], [30], [40],
)
```

### 使い分け

- 値が少ないときは手で `table(...)` を書く。
- CSV の行数が多いときは、読み込み関数を作って流し込む。
- 見出しに数式を入れる場合は `$a$` のように書く。

## CSV を表にする

CSV をそのまま Typst の表に変換すると、同じ形式の結果表を繰り返し使いやすい。

### ヘッダなし CSV の例

```typst
#let rows = read("data.csv").trim().split("\n").map(line => line.split(","))
#let cells = rows.map(row => (
  [#row.at(0)],
  [#row.at(1)],
  [#row.at(2)],
  [#row.at(3)],
)).flatten()

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.6pt,
  [A], [B], [回数], [解],
  ..cells,
)
```

### ヘッダ付き CSV の例

```typst
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
```

### 使うときのポイント

- CSV の1行目を見出しにするなら、関数化しておくと楽。
- 表の列幅は `1fr` を基本にして、必要なら `2fr` などで調整する。
- 数値が長いときは列幅を広めにする。

## レポート全体の流れ

- タイトルページを置く。
- `#pagebreak()` で本文に切り替える。
- 各課題では、まず条件を1文で書く。
- 次に数式や設定値を書く。
- 最後に表で結果を示す。

## そのまま使える文の型

- 「条件を変えて実行し、結果を比較した。」
- 「初期値を変更すると、収束先と反復回数が変化した。」
- 「収束条件を変更し、計算回数への影響を確認した。」
- 「表の結果から、反復回数は設定条件に依存することが分かる。」
- 「詳細な結果は下の表に示す。」
