(run-with-idle-timer 1 t
	(lambda () (save-some-buffers t))
)

(editorconfig-mode t)

(use-package treesit-auto
	:config
	(global-treesit-auto-mode)
	:custom
	(treesit-auto-install t)
	:ensure t
)

(setq create-lockfiles nil)

(provide 'behaviour-config)
