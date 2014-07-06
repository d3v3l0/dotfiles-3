;;; 95-modeline --- modeline configuration
;;; Commentary:
;;; Code:

;; Smart mode line
(use-package smart-mode-line
  :ensure smart-mode-line
  :init
  (progn
    (setq sml/theme 'respectful
	  sml/show-client t
	  sml/hidden-modes '(" ,"       ; subword
			     " Abbrev"  ; abbrev
			     " AC"      ; auto-complete
			     " Dim"     ; auto-dim-other-buffers
			     " Fld"     ; folding
			     " GitFlow" ; magit-gitflow
			     " hs"      ; hideshow
			     " yas"     ; yasnippet
			     )
	  sml/replacer-regexp-list
	  '(("^/ssh:.*:" ":SSH:")
	    ("^/sudo:.*:" ":SU:")
	    ("^~/.config/" ":C:")
	    ("^~/Dropbox/" ":DB:")
	    ("^~/findspire/findspire-front/" ":FS:")
	    ("^:FS:findspire/" ":FSf:")
	    ))
    (display-battery-mode 1)
    (sml/setup)))

;;; init-95-modeline.el ends here
