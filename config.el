(setq user-full-name "Harry Tucker")

(use-package! kubernetes-evil)
(use-package! kubel-evil)

(setq tramp-methods ())

(require 'ox-latex)
(require 'ox-bibtex)

(add-to-list 'org-latex-packages-alist '("" "minted"))
(add-to-list 'org-latex-packages-alist '("" "color"))

(setq org-latex-listings 'minted org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(add-to-list 'org-latex-packages-alist '("" "booktabs"))
(add-to-list 'org-latex-packages-alist '("" "tabularx"))

(setq font-latex-fontify-sectioning 1.3)

(map! (:when (featurep! :lang latex)
       (:map LaTeX-mode-map
        :localleader
        :desc "Compile" "c" #'TeX-command-run-all
        :desc "Insert environment" "e" #'LaTeX-environment
        :desc "Insert section" "s" #'LaTeX-section
        :desc "Format document" "f" #'LaTeX-fill-buffer
        :desc "Fold buffer" "," #'TeX-fold-buffer
        :desc "Unfold buffer" "." #'TeX-fold-clearout-buffer)))

(require 'tex-fold)

(add-hook 'LaTeX-mode-hook #'TeX-fold-mode)
(add-hook 'after-find-file 'TeX-fold-buffer t)
(add-hook 'LaTeX-mode-hook 'font-latex-update-sectioning-faces)

(add-hook 'LaTeX-mode-hook #'orgtbl-mode)

(setq TeX-view-program-selection '((output-pdf "PDF Tools")
        (output-pdf "Zathura")
        ((output-dvi has-no-display-manager) "dvi2tty")
        ((output-dvi style-pstricks) "dvips and gv")
        (output-dvi "xdvi")
        (output-pdf "Evince")
        (output-html "xdg-open")
        (output-pdf "preview-pane")))

(flycheck-define-checker proselint
  "A linter for prose."
  :command ("proselint" source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
            (id (one-or-more (not (any " "))))
            (message) line-end))
  :modes (markdown-mode latex-mode gfm-mode))

(add-to-list 'flycheck-checkers 'proselint)

(defun texcount ()
  (interactive)
  (let*
    ( (this-file (buffer-file-name))
      (enc-str (symbol-name buffer-file-coding-system))
      (enc-opt
        (cond
          ((string-match "utf-8" enc-str) "-utf8")
          ((string-match "latin" enc-str) "-latin1")
          ("-encoding=guess")
      ) )
      (word-count
        (with-output-to-string
          (with-current-buffer standard-output
            (call-process "texcount" nil t nil "-0" enc-opt this-file)
    ) ) ) )
    (message word-count)
) )
(add-hook 'LaTeX-mode-hook (lambda () (define-key LaTeX-mode-map "\C-cw" 'texcount)))
(add-hook 'latex-mode-hook (lambda () (define-key latex-mode-map "\C-cw" 'texcount)))

(setq doom-theme 'doom-dracula)
(setq doom-font (font-spec :family "Fira Code" :size 14))

(setq doom-themes-treemacs-theme "doom-colors")

(setq display-line-numbers-type 'relative)

(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(require 'sql)
(sql-set-product 'postgres)

(setq lsp-rust-server 'rust-analyzer)
(setq rustic-lsp-server 'rust-analyzer)

(setq lsp-rust-analyzer-proc-macro-enable t)
(setq lsp-rust-analyzer-cargo-load-out-dirs-from-chec:wk t)
