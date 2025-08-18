(use-package lsp-mode
	:bind ("C-." . lsp-execute-code-action)
	:commands (lsp lsp-deferred)
	:custom
	(lsp-keymap-prefix "C-c l")
	(lsp-auto-configure t)
	:ensure t
	:hook (lsp-mode . lsp-enable-which-key-integration)
)

(use-package lsp-diagnostics
	:after flycheck
	:config (lsp-diagnostics-flycheck-enable)
)

(use-package lsp-ui
	:commands lsp-ui-mode
	:custom (lsp-ui-doc-show-with-cursor t)
	:ensure t
)

(use-package lsp-treemacs
	:commands lsp-treemacs-errors-list
	:config (lsp-treemacs-sync-mode t)
	:ensure t
	:init (setq lsp-treemacs-theme "nerd-icons")
)

(use-package dap-mode
	:after lsp-mode
	:ensure t
)

(use-package flycheck
	:ensure t
	:init (global-flycheck-mode)
)

(use-package dockerfile-mode
	:defer t
	:ensure t
)

(use-package projectile
	:config
	(projectile-mode t)
	(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
	:custom (projectile-project-search-path '("~/"))
	:ensure t
)

(use-package yaml-mode
	:defer t
	:ensure t
	:hook ((yaml-mode yaml-ts-mode) . (lambda ()
																			(setq-local indent-tabs-mode nil)
																			(setq-local yaml-indent-offset 2)
																		)
				)
)

(require 'guile-config)
(require 'python-config)

(provide 'code-config)
