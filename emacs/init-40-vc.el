;;; 40-vc --- version control
;;; Commentary:
;;; Code:

(use-package magit
  :ensure t
  :bind (("C-<"      . magit-status)
	 ("C-\\"     . magit-status)
	 ("C-c C-<"  . magit-blame)
	 ("C-c C-\\" . magit-blame)
	 ("C-M-<"    . vc-git-grep)
	 ("C-M-\\"   . vc-git-grep))
  :demand t
  :init
  (setq magit-process-popup-time 2
        magit-auto-revert-mode-lighter nil
        magit-last-seen-setup-instructions "1.4.0"
        magit-revert-buffers 'silent
        magit-push-always-verify nil
        vc-follow-symlinks t))

(use-package forge
  :ensure t
  :after magit
  :custom
  (forge-add-pullreq-refspec 'ask))

;; gitflow
;; (use-package magit-gitflow
;;   :ensure t
;;   :commands turn-on-magit-gitflow
;;   :diminish magit-gitflow-mode
;;   :init
;;   (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))

;; gitignore
(use-package gitignore-mode
  :ensure t)

;; Use SSH agent
(setenv "SSH_AUTH_SOCK"
	(format "/run/user/%d/gnupg/S.gpg-agent.ssh" (user-uid)))

;;; init-40-vc.el ends here
