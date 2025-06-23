(cua-mode t)

(use-package dtrt-indent
	:custom
	(dtrt-indent-run-after-smie t)
	:config
	(dtrt-indent-global-mode)
	:ensure t
	:hook
	(prog-mode . dtrt-indent-mode)
)

(setq-default indent-tabs-mode t
	standard-indent 2
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

(add-hook 'python-mode-hook #'my/python-tab-setup)

(provide 'keys-config)
