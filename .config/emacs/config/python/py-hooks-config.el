(use-package lsp-mode
	:hook ((python-mode . lsp-deferred)
				 (python-ts-mode . lsp-deferred)
				)
)

(add-hook 'python-mode-hook
					(lambda ()
						(setq-local flycheck-checkers '(python-ruff python-dmypy))
					)
)

(add-hook 'python-ts-mode-hook
					(lambda ()
						(setq-local flycheck-checkers '(python-ruff python-dmypy))
					)
)


(defun my/python-tab-setup ()
	"Ensure Python uses literal tabs and proper visual width."
	(dtrt-indent-mode t)
	(setq-local tab-width 2)

	(when indent-tabs-mode
		(setq-local indent-line-function #'tab-to-tab-stop)
	)

	(unless indent-tabs-mode
		(setq-local python-indent-offset standard-indent)
	)
)

(add-hook 'python-ts-mode-hook #'my/python-tab-setup)
(add-hook 'python-mode-hook #'my/python-tab-setup)

(provide 'py-hooks-config)
