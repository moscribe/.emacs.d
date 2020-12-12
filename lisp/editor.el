;;; editor.el --- configs for Emacs settings
;;
;;; Commentary:
;;
;;; Code:

;; Resolve symlinks when opening files
(setq find-file-visit-truename t
      vc-follow-symlinks t)

(setq find-file-suppress-same-file-warnings t)

;; Create missing directory when we open a file that doesn't exist under
;; a directory tree tha may not exist.
(add-hook 'find-file-not-found-hooks
	  (lambda ()
	    (unless (file-remote-p buffer-file-name)
	      (let ((parent-directory (file-name-directory buffer-file-name)))
		(and (not (file-directory-p parent-directory))
		     (y-or-n-p (format "Directory `%s' does not exist! Create it? "
				       parent-directory))
		     (progn (make-directory parent-directory)
			    t))))))

;; Don't generate backups or lockfiles.
(setq create-lockfiles nil
      make-backup-files nil
      ring-bell-function 'ignore
      ;; build-in packages
      version-control t
      backup-by-copying t
      delete-old-versions t
      kept-old-versions 5
      kept-new-versions 5
      backup-directory-alist user/backup-directory-alist
      tramp-backup-directory-alist backup-directory-alist)

(setq-default scroll-step 1) ;; smooth scroll

(setq-default auto-image-file-mode t)

(setq auto-save-list-file-prefix user/auto-save-list-prefix)

(setq-default initial-scratch-message nil
              inhibit-splash-screen t
              initial-major-mode 'text-mode
              frame-title-format "%b")

;;; Formatting
(setq-default indent-tabs-mode nil
              tab-width 4
              tab-always-indent nil)

(setq-default fill-column 80)

(setq-default word-wrap t)

(setq-default truncate-lines t)

;; Default to soft line-wrapping in text modes.
(add-hook 'text-mode-hook #'visual-line-mode)

(unless (assq 'menu-bar-lines default-frame-alist)
  (add-to-list 'default-frame-alist '(menu-bar-lines . 0))
  (add-to-list 'default-frame-alist '(tool-bar-lines . 0))
  (add-to-list 'default-frame-alist '(vertical-scroll-bars)))

(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)
(delete-selection-mode 1)
(electric-pair-mode 1)
(size-indication-mode t)

(add-hook 'emacs-startup-hook #'window-divider-mode)

;; Don't display floating tooltips;
(when (bound-and-true-p tooltip-mode)
  (tooltip-mode -1))



;;; Build-in packages

(use-package paren
  :hook (after-init . show-paren-mode)
  :config
  (setq show-paren-delay 0.1
        show-paren-highlight-openparen t
        show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t))
  (use-package recentf
    :defer 1
    :commands (recentf-save-list)
    :init
    (progn
      (add-hook 'find-file-hook (lambda () (unless recentf-mode
					     (recentf-mode)
					     (recentf-track-opened-file))))
      (setq recentf-save-file user/recentf-save-file
	    recentf-max-saved-items 1000
	    recentf-auto-cleanup 'never
	    recentf-auto-save-timer (run-with-idle-timer 600 t
							 'recentf-save-list)))
    )

(use-package display-line-numbers
  :hook
  (prog-mode . display-line-numbers-mode)
  )

;;
(use-package saveplace
  :hook (after-init . save-place-mode)
  :init
  (setq save-place-file user/save-place-file)
  )

(use-package subword
  :hook (after-init . global-subword-mode)
  :diminish subword-mode)

(use-package winner-mode
  :ensure nil
  :hook (after-init . winner-mode))

(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode))

(use-package imenu
  :defer t
  :bind (("C-c j i" . 'imenu))
  )


;;; Minibuffers
;; Allow for minibuffer-ception.
(setq enable-recursive-minibuffers t)

(setq echo-keystrokes 0.02)
(setq resize-mini-windows 'grow-only
      max-mini-window-height 0.15)

(fset #'yes-or-no-p #'y-or-n-p)

;; Try really hard to keep the cursor from getting stuce in the read-only prompt
;; portion of the minibuffer.
(setq minibuffer-prompt-properties
      '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)


(provide 'editor)
;;; editor.el ends here