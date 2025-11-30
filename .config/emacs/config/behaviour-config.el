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
	)

(use-package cape
	:after corfu
	:bind ("C-SPC" . completion-at-point)
	:init
	(add-to-list 'completion-at-point-functions #'cape-dabbrev)
	(add-to-list 'completion-at-point-functions #'cape-file)
	(add-to-list 'completion-at-point-functions #'cape-keyword)
	(add-to-list 'completion-at-point-functions #'cape-symbol)
	(add-to-list 'completion-at-point-functions #'cape-tex)
	)

(use-package orderless
	:ensure t
	:init
	(setq completion-styles '(orderless basic))
	(setq completion-category-defaults nil)
	(setq completion-category-overrides
				'((file (styles partial-completion))))
	)

(use-package lsp-mode
	:commands lsp
	:config
	(add-to-list 'completion-at-point-functions #'cape-lsp)
	)

(use-package marginalia
	:ensure t
	:init (marginalia-mode)
	)

(use-package swiper
	:bind ("C-f" . swiper)
	:ensure t
	)

(use-package treesit-auto
	:config (global-treesit-auto-mode)
	:custom (treesit-auto-install nil)
	:init
	(setq treesit-language-source-alist
				'((bash       . ("https://github.com/tree-sitter/tree-sitter-bash.git" "v0.23.3"))
					(c          . ("https://github.com/tree-sitter/tree-sitter-c.git" "v0.23.6"))
					(cpp        . ("https://github.com/tree-sitter/tree-sitter-cpp.git" "v0.23.4"))
					(css        . ("https://github.com/tree-sitter/tree-sitter-css.git" "v0.23.2"))
					(html       . ("https://github.com/tree-sitter/tree-sitter-html.git" "v0.23.2"))
					(json       . ("https://github.com/tree-sitter/tree-sitter-json.git" "v0.24.8"))
					(python     . ("https://github.com/tree-sitter/tree-sitter-python.git" "v0.23.6"))
					(rust       . ("https://github.com/tree-sitter/tree-sitter-rust.git" "v0.23.3"))
					))
	:ensure t
	)

(use-package which-key
	:config (which-key-mode)
	)


;; Hide the cursor in inactive windows.
(setq-default cursor-in-non-selected-windows nil)

(fset 'yes-or-no-p 'y-or-n-p)

(setq auto-save-default nil)
(setq backup-inhibited t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(auto-save-mode nil)

(provide 'behaviour-config)
