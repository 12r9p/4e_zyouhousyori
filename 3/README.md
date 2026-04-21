# 第3回 ニュートン法 実行フロー

## 前提

- 作業ディレクトリ: `3/report`
- 使用ソース: `3/newton1.c`, `3/newton2.c`
- 生成バイナリ: `3/newton1`, `3/newton2`

## 1. 結果CSVを更新

```bash
cd 3/report
./generate_results.sh
```

このコマンドで以下が更新されます。

- `q1.csv`
- `q2.csv`
- `q3.csv`
- `q4.csv`

## 2. レポートPDFを生成

```bash
cd 3/report
typst compile --root .. main.typ main.pdf
```

## 3. 出力物

- レポート: `3/report/main.pdf`
- 実行結果CSV: `3/report/q1.csv` 〜 `3/report/q4.csv`
