(run-with-idle-timer 1 t
										 (lambda () (save-some-buffers t))
										 )

(setq gc-cons-threshold 100000000)

(setq read-process-output-max 1048576)

(editorconfig-mode t)

(use-package vertico
	:config
	(vertico-mode)
	(vertico-mouse-mode)
	:custom (vertico-cycle t)
	:ensure t
	)

(use-package savehist
	:config (savehist-mode)
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
	:ensure t
	:init
	(completion-preview-mode nil)
	(global-corfu-mode)
	(corfu-popupinfo-mode)
	)

(use-package cape
	:after corfu
	:bind ("C-SPC" . completion-at-point)
	:ensure t
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
	:bind (("C-S-f" . consult-grep)
				 ("C-f" . consult-line))
	:ensure t
	)

(use-package embark-consult
	:ensure t
	:after (consult embark)
	)

(use-package treesit-auto
	:config (global-treesit-auto-mode)
	:custom (treesit-auto-install nil)
	:init
	(setq treesit-language-source-alist
				'((bash   . ("https://github.com/tree-sitter/tree-sitter-bash.git" "v0.23.3"))
					(c      . ("https://github.com/tree-sitter/tree-sitter-c.git" "v0.23.6"))
					(cpp    . ("https://github.com/tree-sitter/tree-sitter-cpp.git" "v0.23.4"))
					(css    . ("https://github.com/tree-sitter/tree-sitter-css.git" "v0.23.2"))
					(html   . ("https://github.com/tree-sitter/tree-sitter-html.git" "v0.23.2"))
					(json   . ("https://github.com/tree-sitter/tree-sitter-json.git" "v0.24.8"))
					(python . ("https://github.com/tree-sitter/tree-sitter-python.git" "v0.23.6"))
					(rust   . ("https://github.com/tree-sitter/tree-sitter-rust.git" "v0.23.3"))
					(elixir . ("https://github.com/elixir-lang/tree-sitter-elixir" "v0.3.4"))
					))
	:ensure t
	)

(use-package which-key
	:config (which-key-mode)
	)

;; Auto close parentesis
(use-package elec-pair
	:config
	(electric-pair-mode t)
	)

;; Hide the cursor in inactive windows.
(setq-default cursor-in-non-selected-windows nil)

;; Type y/n to accept instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Remove anoying # and ~ files
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(auto-save-mode nil)

(provide 'behaviour-config)
