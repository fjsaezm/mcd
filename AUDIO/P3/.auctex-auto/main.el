(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("babel" "english") ("hyperref" "final" "colorlinks=true" "linkcolor=black" "citecolor=black") ("biblatex" "backend=bibtex" "style=numeric" "sorting=nyt") ("datetime" "yyyymmdd") ("FiraSans" "sfdefault") ("fontenc" "T1")))
   (add-to-list 'LaTeX-verbatim-environments-local "minted")
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "blindtext"
    "charter"
    "inputenc"
    "microtype"
    "babel"
    "amsthm"
    "amsmath"
    "amssymb"
    "float"
    "hyperref"
    "graphicx"
    "multicol"
    "xcolor"
    "marvosym"
    "wasysym"
    "rotating"
    "censor"
    "listings"
    "pseudocode"
    "booktabs"
    "tikz-qtree"
    "biblatex"
    "csquotes"
    "datetime"
    "fancyhdr"
    "mathtools"
    "cancel"
    "minted"
    "caption"
    "subcaption"
    "mdframed"
    "FiraSans"
    "fontenc"
    "titlesec")
   (TeX-add-symbols
    '("norm" 1)
    '("note" 1)
    "gaussian"
    "R"
    "ps"
    "ns"
    "inline")
   (LaTeX-add-bibliographies
    "b")
   (LaTeX-add-mathtools-DeclarePairedDelimiters
    '("abs" "")))
 :latex)

