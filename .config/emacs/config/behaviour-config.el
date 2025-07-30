(run-with-idle-timer 1 t
	(lambda () (save-some-buffers t))
)

(editorconfig-mode t)

(use-package ivy
	:config (ivy-mode)
	:ensure t
)

(use-package swiper
	:bind ("C-f" . swiper)
	:ensure t
)

(use-package counsel
	:config (counsel-mode)
	:ensure t
)

(use-package treesit-auto
	:config (global-treesit-auto-mode)
	:custom (treesit-auto-install t)
	:ensure t
)

(use-package which-key
	:config (which-key-mode)
)

(fset 'yes-or-no-p 'y-or-n-p)

(setq create-lockfiles nil)

(provide 'behaviour-config)
