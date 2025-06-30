(use-package lsp-mode
	:commands (lsp lsp-deferred)
	:custom
	(lsp-keymap-prefix "C-c l")
	(lsp-auto-configure t)
	:ensure t
)

(use-package flycheck
	:ensure t
	:init (global-flycheck-mode)
)

(use-package prog-mode
	:custom
	(which-func-display 'header)
	:ensure nil
	:hook ((prog-mode . which-function-mode))
	:init
	(setq which-func-unknown "")
)

(require 'python-config)

(provide 'code-config)
