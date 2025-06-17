(cua-mode t)

(use-package dtrt-indent
	:ensure t
	:hook (prog-mode . dtrt-indent-mode)
	:config
	(setq dtrt-indent-run-after-smie t)
)

(setq-default indent-tabs-mode t
					tab-width 3
					standard-indent 2
)

(defun my/python-tab-setup ()
	"Ensure Python uses literal tabs and proper visual width."
	(dtrt-indent-mode t)
	(setq-local tab-width 3)

	(when indent-tabs-mode
		(setq-local indent-line-function #'tab-to-tab-stop)
	)

	(unless indent-tabs-mode
		(setq-local python-indent-offset standard-indent)
	)
)

(add-hook 'python-mode-hook #'my/python-tab-setup)

(provide 'keys-config)
