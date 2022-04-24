all: $(file) clean

$(file): $(file).tex
	pdflatex --shell-escape $(file).tex
	pdflatex --shell-escape $(file).tex
	bibtex $(file)
	pdflatex --shell-escape $(file).tex


clean: $(file)
	rm *.bbl *.aux *.blg *.fdb_latexmk *.out *.log *.toc *.fls *.lof *.lot *.run.xml *.bcf
	rm -rf _minted-$(file)/
