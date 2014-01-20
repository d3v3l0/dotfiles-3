;;; 20-tex --- LaTeX
;;; Commentary:
;;; Code:

;; Basic settings
(eval-after-load 'tex
  '(setq TeX-auto-save t
	 TeX-parse-self t
	 TeX-save-query nil
	 TeX-PDF-mode t))
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'flyspell-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(eval-after-load 'reftex
  '(setq reftex-plug-into-AUCTeX t))

;; Auto-fill for LaTeX
(defun schnouki/latex-auto-fill ()
  "Turn on auto-fill for LaTeX mode."
  (turn-on-auto-fill)
  (set-fill-column 80)
  (setq default-justification 'left))
(add-hook 'LaTeX-mode-hook 'schnouki/latex-auto-fill)

;; Fill for BibTeX
(eval-after-load 'bibtex
  '(progn
     (setq bibtex-align-at-equal-sign t)
     (add-hook 'bibtex-mode-hook (lambda () (set-fill-column 120)))))

;; Compilation command
(add-hook 'LaTeX-mode-hook (lambda () (setq compile-command "latexmk -pdf")))

;; Prevent ispell from verifying some LaTeX commands
;; http://stat.genopole.cnrs.fr/dw/~jchiquet/fr/latex/emacslatex
(defvar schnouki/ispell-tex-skip-alists
      '("cite" "nocite"
	"includegraphics"
	"author" "affil"
	"ref" "eqref" "pageref"
	"label"))
(setq ispell-tex-skip-alists
      (list
       (append (car ispell-tex-skip-alists)
	       (mapcar #'(lambda (cmd) (list (concat "\\\\" cmd) 'ispell-tex-arg-end)) schnouki/ispell-tex-skip-alists))
       (cadr ispell-tex-skip-alists)))

;; Indentation with align-current in LaTeX environments
(defvar schnouki/LaTeX-align-environments '("tabular" "tabular*"))
(eval-after-load 'latex
  '(add-hook 'LaTeX-mode-hook
	     (lambda ()
	       (require 'align)
	       (setq LaTeX-indent-environment-list
		     ;; For each item in the list...
		     (mapcar (lambda (item)
			       ;; The car is an environment
			       (let ((env (car item)))
				 ;; If this environment is in our list...
				 (if (member env schnouki/LaTeX-align-environments)
				     ;; ...then replace this item with a correct one
				     (list env 'align-current)
				   ;; else leave it alone
				   item)))
			     LaTeX-indent-environment-list)))))

;; Use dvipdfmx to convert DVI files to PDF in AUCTeX
(eval-after-load 'tex
  '(add-to-list 'TeX-command-list
                '("DVI to PDF" "dvipdfmx %d" TeX-run-command t t) t))

;; Default scaling for preview-latex
(setq-default preview-scale 1.4
	      preview-scale-function '(lambda () (* (/ 10.0 (preview-document-pt)) preview-scale)))

;; SyncTeX (http://www.emacswiki.org/emacs/AUCTeX#toc19)
(defun synctex/un-urlify (fname-or-url)
  "A trivial function that replaces a prefix of file:/// with just /."
  (if (string= (substring fname-or-url 0 8) "file:///")
      (substring fname-or-url 7)
    fname-or-url))

(defun synctex/evince-sync (file linecol &rest ignored)
  "Handle synctex signal from Evince."
  (let* ((fname (url-unhex-string (synctex/un-urlify file)))
         (buf (find-buffer-visiting fname))
         (line (car linecol))
         (col (cadr linecol)))
    (if (null buf)
        (message "[Synctex]: %s is not opened..." fname)
      (switch-to-buffer buf)
      (goto-char (point-min))
      (forward-line (1- (car linecol)))
      (unless (= col -1)
        (move-to-column col)))))

(defvar *dbus-evince-signal* nil)

(defun synctex/enable-evince-sync ()
  "Enable synctex with Evince over DBus."
  (require 'dbus)
  (when (and
         (eq window-system 'x)
         (fboundp 'dbus-register-signal))
    (unless *dbus-evince-signal*
      (setf *dbus-evince-signal*
            (dbus-register-signal
             :session nil "/org/gnome/evince/Window/0"
             "org.gnome.evince.Window" "SyncSource"
             'synctex/evince-sync)))))

(add-hook 'LaTeX-mode-hook 'synctex/enable-evince-sync)

;; Suppressions for chktex (used by flycheck-mode)
(eval-after-load 'flycheck
  '(setq flycheck-checker-tex
	 '(:command
	   ("checktex" "-v0" "-q" "-I" "-n1" "-n13" "-n19" source-inplace)
	   :modes (latex-mode plain-tex-mode))))

;;; init-20-tex.el ends here
