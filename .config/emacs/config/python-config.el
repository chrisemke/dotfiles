(use-package lsp-mode
	:custom
	(lsp-ruff-server-command "")
	(lsp-pylsp-plugins-ruff-enabled t)
	(lsp-pylsp-plugins-mypy-enabled t)
	;; (lsp-pylsp-plugins-mypy-dmypy t)
	(lsp-pylsp-plugins-mypy-report-progress t)
	(lsp-pylsp-plugins-flake8-enabled nil)
	(lsp-pylsp-plugins-pydocstyle-enabled nil)
	:hook ((python-mode python-ts-mode) . lsp-deferred)
)

(use-package dap-python
	:config (dap-auto-configure-mode t)
	:custom (dap-python-debugger 'debugpy)
	:hook (((python-mode python-ts-mode) . dap-ui-mode)
				 ((python-mode python-ts-mode) . dap-mode)
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

(provide 'python-config)
