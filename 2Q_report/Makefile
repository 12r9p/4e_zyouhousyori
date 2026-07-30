# ----------------------------------------------------
# Makefile for 2Q Report
# ----------------------------------------------------

PYTHON = ./venv/bin/python3
TYPST = typst

.PHONY: all run pdf clean

all: run pdf

run:
	$(PYTHON) generate_results.py

pdf:
	$(TYPST) compile --root .. 22-佐藤匠-課題2.typ 22-佐藤匠-課題2.pdf

clean:
	rm -f spline minjijo tyouhou_mod daikei euler rungekt2
	rm -f data/*_log.txt data/*_output.csv data/minjijo_output_*.csv
	rm -f plots/*.png
	rm -f 22-佐藤匠-課題2.pdf
