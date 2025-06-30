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

(provide 'keys-config)
