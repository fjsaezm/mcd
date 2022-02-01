(TeX-add-style-hook
 "config"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "inputenc"
    "amsmath"
    "amssymb"
    "upgreek"
    "amsthm"
    "mathrsfs"
    "enumitem"
    "hyperref"
    "pgf"
    "tikz"
    "tkz-euclide"
    "capt-of"
    "xcolor")
   (TeX-add-symbols
    '("nn" 1)
    '("norm" 1)
    '("Ker" 2)
    "subject"
    "autor"
    "grado"
    "universidad"
    "enlaceweb"
    "R"
    "iif")
   (LaTeX-add-xcolor-definecolors
    "50"
    "300"
    "500"
    "700")
   (LaTeX-add-amsthm-newtheorems
    "nth"
    "nprop"
    "ncor"
    "lema"
    "ndef"
    "note"
    "remark"
    "example"
    "exer"
    "sol"))
 :latex)

