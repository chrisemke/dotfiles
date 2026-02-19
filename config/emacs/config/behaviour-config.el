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
	(corfu-auto-delay 0.1)
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
										 #'cape-file
										 #'cape-keyword
										 )))
	)

(use-package cape
	:after corfu
	:bind ("C-SPC" . completion-at-point)
	:config (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
	:custom
	(completion-category-overrides '((eglot (styles orderless))
																	 (eglot-capf (styles orderless))))
	:ensure t
	:hook (eglot-managed-mode . my/eglot-capf)
	:init
	(add-to-list 'completion-at-point-functions #'cape-dabbrev)
	(add-to-list 'completion-at-point-functions #'cape-file)
	(add-to-list 'completion-at-point-functions #'cape-keyword)
	)

(use-package orderless
	:ensure t
	:init
	(setq completion-styles '(orderless basic))
	(setq completion-category-defaults nil)
	(setq completion-category-overrides
				'((file (styles partial-completion))))
	)

(use-package marginalia
	:ensure t
	:init (marginalia-mode)
	)

(use-package consult
	:bind (("C-S-f" . consult-ripgrep)
				 ("C-f" . consult-line))
	:ensure t
	)

(use-package embark-consult
	:ensure t
	:after (consult embark)
	)

(use-package treesit-auto
	:config (global-treesit-auto-mode)
	(dolist (lang '(bash c cpp css dockerfile elixir heex html json lua python rust yaml))
		(unless (treesit-language-available-p lang)
			(treesit-install-language-grammar lang)))
	:custom (treesit-auto-install t)
	(treesit-font-lock-level 4)
	:init
	(setq treesit-language-source-alist
				'((bash				. ("https://github.com/tree-sitter/tree-sitter-bash" "v0.23.3"))
					(c					. ("https://github.com/tree-sitter/tree-sitter-c" "v0.23.6"))
					(cpp				. ("https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4"))
					(css				. ("https://github.com/tree-sitter/tree-sitter-css" "v0.23.2"))
					(dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile" "v0.2.0"))
					(elixir			. ("https://github.com/elixir-lang/tree-sitter-elixir" "v0.3.4"))
					(heex				. ("https://github.com/phoenixframework/tree-sitter-heex" "v0.8.0"))
					(html				. ("https://github.com/tree-sitter/tree-sitter-html" "v0.23.2"))
					(json				. ("https://github.com/tree-sitter/tree-sitter-json" "v0.24.8"))
					(lua				. ("https://github.com/tree-sitter-grammars/tree-sitter-lua" "v0.3.0"))
					(python			. ("https://github.com/tree-sitter/tree-sitter-python" "v0.23.6"))
					(rust				. ("https://github.com/tree-sitter/tree-sitter-rust" "v0.23.3"))
					(yaml				. ("https://github.com/tree-sitter-grammars/tree-sitter-yaml" "v0.7.2"))
					))
	:ensure t
	)

(use-package which-key
	:config (which-key-mode)
	:ensure nil
	)

;; Auto close parentesis
(use-package elec-pair
	:config (electric-pair-mode t)
	:ensure nil
	)

;; Set _ as a word for double click selection
(add-hook 'after-change-major-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; Hide the cursor in inactive windows.
(setq-default cursor-in-non-selected-windows nil)

;; Type y/n to accept instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Always sync files to disk
(global-auto-revert-mode t)

;; Truncate long lines instead of breaking lines
(setq-default truncate-lines t)

;; Remove anoying # and ~ files
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(auto-save-mode nil)

(provide 'behaviour-config)
