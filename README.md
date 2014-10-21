asciidoc-mode
=============
A simple [asciidoc](http://www.methods.co.nz/asciidoc/) mode for emacs.  To use this mode, first add it to your load path in .emacs:

    (add-to-list 'load-path "{code location}")

Once this is in your load path add a require statement to source it

    (require 'asciidoc-mode)

To automatically start the mode when visiting an asciidoc file add the
following to your .emacs file:

    (add-to-list 'auto-mode-alist '("\\.doc$" . asciidoc-mode))
    (add-to-list 'auto-mode-alist '("\\.asciidoc$" . asciidoc-mode))
    (add-to-list 'auto-mode-alist '("\\.ascii$" . asciidoc-mode))
    (add-to-list 'auto-mode-alist '("\\.txt$" . asciidoc-mode))
    (add-to-list 'auto-mode-alist '("\\.text$" . asciidoc-mode))
