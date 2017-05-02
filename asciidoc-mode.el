;; asciidoc-mode.el -- A customized asciidoc mode
;;
;; jmquigley@outlook.com @ 02/13/2013
;;
;; To use this mode, first add it to your load path in .emacs:
;; 
;; -  (add-to-list 'load-path "{code location}")
;;
;; Once this is in your load path add a require statement to source it
;;
;; -  (require 'asciidoc-mode)
;;
;; To automatically start the mode when visiting an asciidoc file add the
;; following to your .emacs file:
;;
;; -  (add-to-list 'auto-mode-alist '("\\.doc$" . asciidoc-mode))
;; -  (add-to-list 'auto-mode-alist '("\\.asciidoc$" . asciidoc-mode))
;; -  (add-to-list 'auto-mode-alist '("\\.ascii$" . asciidoc-mode))
;; -  (add-to-list 'auto-mode-alist '("\\.txt$" . asciidoc-mode))
;; -  (add-to-list 'auto-mode-alist '("\\.text$" . asciidoc-mode))
;;

(defconst asciidoc-mode-version "0.1")
(defconst asciidoc-options "--backend=html")

(defun asciidoc-compile-file ()
"Takes the current buffer, saves it and generates the asciidoc file 
associated with it and attempts to open it within the current browser."
    (interactive)
    (save-buffer)
    (compile (concat 
        "asciidoc " asciidoc-options " '" (buffer-file-name) "'")))

(defun asciidoc-indent-line ()
    (interactive)
    (move-end-of-line nil))

(defun asciidoc-backtab ()
    (interactive)
    (move-beginning-of-line nil)
    (forward-char 2))

(defun asciidoc-indent-region ()
    (interactive))

(defun asciidoc-return ()
"Intercepts the return key to perform a processing check of your current location."
    (interactive)
    (let ((current-line (thing-at-point 'line)) str)
        (insert "\n")))

(defvar asciidoc-mode-map
       (let ((map (make-sparse-keymap))
             (menu-map (make-sparse-keymap "Asciidoc")))
         (define-key map (kbd "C-c p") 'asciidoc-compile-file)
         (define-key map (kbd "RET") 'asciidoc-return)
         (define-key map (kbd "<backtab>") 'asciidoc-backtab)
          map)
       "Keymap for editing asciidoc files.")

(defvar asciidoc-mode-syntax-table
    (let ((asciidoc-mode-syntax-table (make-syntax-table)))
        (modify-syntax-entry ?_  "w" asciidoc-mode-syntax-table)
        (modify-syntax-entry ?\" "w" asciidoc-mode-syntax-table)
        asciidoc-mode-syntax-table)
    "Syntax table for asciidoc-mode")

;;;###autoload
(define-derived-mode asciidoc-mode text-mode "asciidoc"
"Major mode for modifying Asciidoc markup files.

\\{asciidoc-mode-map}"
    (set-syntax-table asciidoc-mode-syntax-table) 
    (set (make-local-variable 'indent-line-function) 'asciidoc-indent-line)
    (set (make-local-variable 'indent-region-function) 'asciidoc-indent-region)
    (setq jit-lock-contextually t)
    (setq font-lock-multiline t)
    (setq font-lock-defaults '(asciidoc-font-lock-keywords))
    (add-hook 'font-lock-extend-region-functions
              'asciidoc-extend-region))

(defgroup asciidoc-faces nil
  "AsciiDoc highlighting"
  :group 'asciidoc)

(defface asciidoc-h0-face '((t (:foreground "#ffff00")))
"Face for AsciiDoc titles at level 0."
:group 'asciidoc-faces)
(defvar asciidoc-h0 'asciidoc-h0-face)
(defconst asciidoc-h0-re "^.+\n==+?$\\|^= .*")

(defface asciidoc-h1-face '((t (:foreground "#ffaf00")))
"Face for AsciiDoc titles at level 1."
:group 'asciidoc-faces)
(defvar asciidoc-h1 'asciidoc-h1-face)
(defconst asciidoc-h1-re "^.+\n--+?$\\|^== .*")

(defface asciidoc-h2-face '((t (:foreground "#ff8700")))
"Face for AsciiDoc titles at level 2."
:group 'asciidoc-faces)
(defvar asciidoc-h2 'asciidoc-h2-face)
(defconst asciidoc-h2-re "^.+\n~~+?$\\|^=== .*")

(defface asciidoc-h3-face '((t (:foreground "#ff5f00")))
"Face for AsciiDoc titles at level 3."
:group 'asciidoc-faces)
(defvar asciidoc-h3 'asciidoc-h3-face)
(defconst asciidoc-h3-re "^.+\n\\^\\^+?$\\|^==== .*")

(defface asciidoc-h4-face '((t (:foreground "#ff0000")))
"Face for AsciiDoc titles at level 4."
:group 'asciidoc-faces)
(defvar asciidoc-h4 'asciidoc-h4-face)
(defconst asciidoc-h4-re "^.+\n\\+\\++?$\\|^===== .*")

(defface asciidoc-span-face '((t (:foreground "#daa520")))
"Face for selecting a formatting span"
:group 'asciidoc-faces)
(defvar asciidoc-span 'asciidoc-span-face)
(defconst asciidoc-span-re "\\[.+?\\]#.+?#")

(defface asciidoc-block-configuration-face '((t (:foreground "#5f8700")))
"Face for selecting the text between a block configuration element"
:group 'asciidoc-faces)
(defvar asciidoc-block-configuration 'asciidoc-block-configuration-face)
(defconst asciidoc-block-configuration-re "\\[\\[.+?\\]\\]\\|\\[.+?\\]\\|<<.+?>>")

(defface asciidoc-attribute-face '((t (:foreground "#2e8b57")))
"Face for document attributes"
:group 'asciidoc-faces)
(defvar asciidoc-attribute 'asciidoc-attribute-face)
(defconst asciidoc-attribute-re "^:.+?:\\|{.+?[}]")

(defface asciidoc-block-title-face '((t (:foreground "red")))
"Face for section block titles"
:group 'asciidoc-faces)
(defvar asciidoc-block-title 'asciidoc-block-title-face)
(defconst asciidoc-block-title-re "^\\.[^ .].*")

(defface asciidoc-bold-face '((t (:foreground "#0087ff")))
"Face for selection bold text"
:group 'asciidoc-faces)
(defvar asciidoc-bold 'asciidoc-bold-face)
(defconst asciidoc-bold-re "\\*[^*\n]+?\\*")

(defface asciidoc-italic-face '((t (:foreground "#af00ff")))
"Face for selecting italic text"
:group 'asciidoc-faces)
(defvar asciidoc-italic 'asciidoc-italic-face)
(defconst asciidoc-italic-re "_.+?_[ \.\?!]")
 
(defface asciidoc-mono-face '((t (:foreground "#8a8a8a")))
"Face for selecting mono text"
:group 'asciidoc-faces)
(defvar asciidoc-mono 'asciidoc-mono-face)
(defconst asciidoc-mono-re "\\+.+?\\+[ \.\?!]")

(defvar asciidoc-comment 'font-lock-comment-face)
(defconst asciidoc-comment-re "\\(///\\).*\n[^//]*\\1//+$\\|//.*")

(defface asciidoc-list-face '((t (:foreground "#8b0000")))
"Face for selecting the start of a list of elements"
:group 'asciidoc-faces)
(defvar asciidoc-list 'asciidoc-list-face)
(defconst asciidoc-list-re "^[ ]*[*.]+ \\|[ ]+[*.]+ \\|^[ ]*- \\|[ ]+- \\|^[ ]*[a-z0-9]+\\. \\|[ ]+[0-9][0-9]?[0-9]?\\. \\|[ ]+[a-z]\\. ")

(defface asciidoc-url-face '((t (:foreground "#4169e1")))
"Face for selecting url links"
:group 'asciidoc-faces)
(defvar asciidoc-url 'asciidoc-url-face)
(defconst asciidoc-url-re "[hflix][timr][tplnae][pekgf]?[se]?:.+?[]]\\|[hfli][tim][tplna][pekg]?[se]?:.+?[ \n]")

(defface asciidoc-email-face '((t (:foreground "#9acd32")))
"Face for selecting email addresses"
:group 'asciidoc-faces)
(defvar asciidoc-email 'asciidoc-email-face)
(defconst asciidoc-email-re "[a-zA-Z0-9._+-]+@[-+.a-zA-Z0-9]+")

(defface asciidoc-code-face '((t (:foreground "#98f5ff")))
"Face for selecting source code blocks"
:group 'asciidoc-faces)
(defvar asciidoc-code 'asciidoc-code-face)
(defconst asciidoc-code-re "^\n\\([ ]*----+?---$\\)[^\t]*?\\(^\\1\\)$")

(defface asciidoc-admonition-face 
    '((t (:foreground "#af0000" :background "white")))
"Face for admonition notes"
:group 'asciidoc-faces)
(defvar asciidoc-admonition 'asciidoc-admonition-face)
(defconst asciidoc-admonition-re 
    "NOTE:\\|TIP:\\|IMPORTANT:\\|CAUTION:\\|WARNING:")

(defvar asciidoc-keywords
    '("\\<ifdef\\>::" "\\<ifndef\\>::" "\\<endif\\>::" "\\<ifeval\\>::" 
      "\\<include\\>::" "\\<include1\\>::" "\\<sys\\>::" "\\<eval\\>::" 
      "\\<template\\>::" "\\<system\\>::"))
(defconst asciidoc-keywords-re (mapconcat 'identity asciidoc-keywords "\\|"))

(defvar asciidoc-functions
    '("footnote" "footnoteref" "indexterm" "indexterm2" "latexmath" "asciimath"
      "quanda" "glossary" "bibliography" "mailto"))
(defconst  asciidoc-functions-re (regexp-opt asciidoc-functions 'words))

(defvar asciidoc-operators '(""))
(defconst asciidoc-operators-re "::\\|(Q)\\|(V)\\|(C)\\|(R)\\|(TM)\\|->\\|<-\\|=>\\|<=\\|&#[0-9]+?;\\| -- ")

(defvar  asciidoc-font-lock-keywords
    (list
       `(,asciidoc-url-re . asciidoc-url)
       `(,asciidoc-email-re . asciidoc-email)
       `(,asciidoc-comment-re . asciidoc-comment)
       `(,asciidoc-code-re . asciidoc-code)
       `(,asciidoc-list-re . asciidoc-list)
       `(,asciidoc-h0-re . asciidoc-h0)	
       `(,asciidoc-h1-re . asciidoc-h1)
       `(,asciidoc-h2-re . asciidoc-h2)
       `(,asciidoc-h3-re . asciidoc-h3)
       `(,asciidoc-h4-re . asciidoc-h4)
       `(,asciidoc-mono-re . asciidoc-mono)
       `(,asciidoc-bold-re . asciidoc-bold)
       `(,asciidoc-italic-re . asciidoc-italic)
       `(,asciidoc-span-re . asciidoc-span)
       `(,asciidoc-block-configuration-re . asciidoc-block-configuration)
       `(,asciidoc-attribute-re . asciidoc-attribute)
       `(,asciidoc-block-title-re . asciidoc-block-title)
       `(,asciidoc-keywords-re . font-lock-keyword-face)
       `(,asciidoc-functions-re . font-lock-function-name-face)
       `(,asciidoc-operators-re . font-lock-builtin-face)
       `(,asciidoc-admonition-re . asciidoc-admonition)
    ))

(defun asciidoc-extend-region nil
 "Searches the current font-lock region for the existence of a regex.  This
 is used for multiline font-locks."
     (eval-when-compile (defvar font-lock-beg) (defvar font-lock-end))
     (goto-char font-lock-beg)
     (let ((found-point (re-search-backward "^\n" nil t 2)))
         (if found-point
             (progn
               (setq font-lock-beg found-point)
               (goto-char font-lock-end)
               (setq found-point (re-search-forward "^\n" nil t 2))
               (if found-point
                   (setq font-lock-end found-point))))))
				
(provide 'asciidoc-mode)
