(use-package lsp-mode
	:commands (lsp lsp-deferred)
	:custom
	(lsp-keymap-prefix "C-c l")
	(lsp-auto-configure t)
	:ensure t
)

(use-package lsp-ui
	:commands lsp-ui-mode
	:ensure t
)

(use-package lsp-treemacs
	:commands lsp-treemacs-errors-list
	:config (lsp-treemacs-sync-mode t)
	:ensure t
)

(use-package flycheck
	:ensure t
	:init (global-flycheck-mode)
)

(use-package company
	:config (global-company-mode t)
	:custom
	(company-idle-delay 0)
	(company-minimum-prefix-length 1)
	:ensure t
)

(use-package prog-mode
	:custom (which-func-display 'header)
	:ensure nil
	:hook ((prog-mode . which-function-mode))
	:init (setq which-func-unknown "")
)

(require 'python-config)

(provide 'code-config)
