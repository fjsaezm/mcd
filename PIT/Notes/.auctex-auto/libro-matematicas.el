(TeX-add-style-hook
 "libro-matematicas"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("scrartcl" "fontsize=12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("babel" "english" "es-tabla" "es-lcroman" "es-noquoting" "es-minimal") ("mathdesign" "bitstream-charter") ("FiraSans" "scale=0.88" "type1") ("FiraMono" "scale=0.88" "type1") ("fontenc" "T1") ("microtype" "activate={true, nocompatibility}" "final" "tracking=true" "factor=1100" "stretch=10" "shrink=10") ("geometry" "bottom=3.125cm" "top=2.5cm" "left=2.5cm" "right=4.5cm" "marginparwidth=70pt") ("scrlayer-scrpage" "automark") ("tcolorbox" "theorems" "skins" "breakable")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "Chapters/1-basic-models"
    "scrartcl"
    "scrartcl10"
    "babel"
    "graphicx"
    "templatetools"
    "config"
    "mathdesign"
    "FiraSans"
    "FiraMono"
    "fontenc"
    "microtype"
    "geometry"
    "scrlayer-scrpage"
    "hyperref"
    "xpatch"
    "pagecolor"
    "afterpage"
    "tcolorbox"))
 :latex)

