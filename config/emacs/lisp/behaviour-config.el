;; -*- lexical-binding: t; -*-
(run-with-idle-timer 1 t
										 (lambda () (save-some-buffers t))
										 )

(use-package editorconfig
	:config (editorconfig-mode t)
	:ensure nil
	)

(use-package outline-mode
	:custom
	(outline-minor-mode-use-buttons 'in-margins)
	(outline-overlay-button-map nil)
	:ensure nil
	:hook (prog-mode . outline-minor-mode)
	)

(use-package csv-mode
	:defer t
	:ensure t
	)

(use-package vertico
	:config
	(vertico-mode)
	(vertico-mouse-mode)
	:custom (vertico-cycle t)
	:ensure t
	)

;; Left and right side windows occupy full frame height
(use-package emacs
	:custom
	(window-sides-vertical t)
	)

(use-package savehist
	:config (savehist-mode)
	:ensure nil
	)

(use-package corfu
	:config (corfu-popupinfo-mode t)
	:custom
	(corfu-auto t)
	(corfu-auto-prefix 1)
	(corfu-auto-delay 0.5)
	(corfu-cycle t)
	(corfu-separator ?\s)
	(corfu-quit-no-match 'separator)
	(corfu-preview-current 'insert)
	(corfu-preselect-first t)
	(corfu-popupinfo-max-width 80)
	(corfu-popupinfo-max-height 14)
	(corfu-popupinfo-resize t)
	(corfu-popupinfo-direction '(right vertical left))
	(corfu-history-mode t)
	:ensure t
	:init
	(completion-preview-mode nil)
	(global-corfu-mode)
	(corfu-popupinfo-mode)
	)

(defun my/eglot-capf ()
	(setq-local completion-at-point-functions
							(list (cape-capf-super
										 #'eglot-completion-at-point
										 #'cape-dabbrev
										 #'cape-keyword
										 )))
	)

(use-package cape
	:after corfu
	:bind ("C-c p" . cape-prefix-map)
	:config (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
	:custom
	(completion-category-overrides '((eglot (styles orderless))
																	 (eglot-capf (styles orderless))))
	:ensure t
	:hook (eglot-managed-mode . my/eglot-capf)
	:init
	(add-hook 'completion-at-point-functions #'cape-dabbrev)
	(add-hook 'completion-at-point-functions #'cape-file)
	(add-hook 'completion-at-point-functions #'cape-keyword)
	)

(use-package orderless
	:defer t
	:ensure t
	:init
	(setopt completion-styles '(orderless basic)
					completion-category-defaults nil
					completion-category-overrides '((file (styles partial-completion))))
	)

(use-package marginalia
	:defer t
	:ensure t
	:init (marginalia-mode)
	)

(use-package consult
	:bind
	("C-c F" . consult-ripgrep)
	("C-c f" . consult-line)
	:ensure t
	)

(use-package treesit
	:config
	(let ((lang-file-alist '((bash            . sh-script)
													 (c               . c-ts-mode)
													 (cpp             . c-ts-mode)
													 (css             . css-mode)
													 (dockerfile      . dockerfile-ts-mode)
													 (elixir          . elixir-ts-mode)
													 (heex            . heex-ts-mode)
													 (html            . html-ts-mode)
													 (json            . json-ts-mode)
													 (lua             . lua-ts-mode)
													 (markdown        . markdown-ts-mode)
													 (markdown-inline . markdown-ts-mode)
													 (python          . python)
													 (rust            . rust-ts-mode)
													 (yaml            . yaml-ts-mode))))
		(mapc (lambda (lang)
						(unless (treesit-language-available-p lang)
							(require (alist-get lang lang-file-alist) nil t)
							(treesit-install-language-grammar lang)))
					(mapcar #'car lang-file-alist)))
	:custom
	(treesit-auto-install-grammar 'always)
	(treesit-enabled-modes t)
	(treesit-font-lock-level 4)
	:ensure nil
	)

(use-package which-key
	:config (which-key-mode)
	:defer t
	:ensure nil
	)

;; Auto close parentesis
(use-package elec-pair
	:config (electric-pair-mode t)
	:ensure nil
	)

(use-package move-text
	:bind
	("M-<up>" . move-text-up)
	("M-p" . move-text-up)
	("M-<down>" . move-text-down)
	("M-n" . move-text-down)
	:defer t
	:ensure t
	)

(use-package dired
	:bind
	(:map dired-mode-map
				("<mouse-2>" . dired-mouse-find-file)
				("<mouse-3>" . dired-mouse-find-file-other-window))
	:custom
	;; Set dired default args do be more organized.
	(dired-listing-switches "-Ag --human-readable --group-directories-first --no-group --dired")
	(dired-kill-when-opening-new-dired-buffer t)
	:ensure nil
	)

;; Set _ as a word for double click selection.
(add-hook 'after-change-major-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; Type y/n to accept instead of yes/no.
(fset 'yes-or-no-p 'y-or-n-p)

;; Always sync files to disk.
(global-auto-revert-mode t)

;; Delete selection when type.
(delete-selection-mode t)


(setopt
 cursor-in-non-selected-windows nil  ;; Hide the cursor in inactive windows.
 truncate-lines t  ;; Truncate long lines instead of breaking lines.
 mouse-shift-adjust-mode t  ;; Shift click should select.
 ;; Remove anoying # and ~ files.
 auto-save-default nil
 create-lockfiles nil
 make-backup-files nil
 ;; Configure auto-save-visited-mode (the modern replacement)
 auto-save-visited-interval 1   ;; seconds of idle before saving
 save-silently t ;; no "Wrote /path/to/file"
 )
(auto-save-visited-mode 1)



(provide 'behaviour-config)
