(use-package catppuccin-theme
	:ensure t
	:init
	(setq catppuccin-flavor 'mocha)
	:config
	(load-theme 'catppuccin t)
)

(setq inhibit-startup-screen t
		inhibit-startup-message t
		initial-scratch-message nil
		frame-resize-pixelwise t
)

(setq-default cursor-type 'bar)

(global-display-line-numbers-mode t)
(column-number-mode t)

(use-package treemacs
	:ensure t
	:bind
	("C-\\" . treemacs)
	:config
	(treemacs-follow-mode t)
	(treemacs-git-mode 'deferred)
	(treemacs-indent-guide-mode t)
	:hook
	(treemacs-mode . (lambda () (display-line-numbers-mode 0)))
)

(use-package treemacs-projectile
	:after (treemacs projectile)
	:ensure t
	:config
	(treemacs-project-follow-mode t)
)

(use-package treemacs-magit
	:after (treemacs magit)
	:ensure t
)

(use-package diff-hl
	:ensure t
	:init
	(global-diff-hl-mode)
)

(use-package blamer
	:ensure t
	:config
	(setq blamer-type 'visual
			blamer-max-commit-message-length 50
			blamer-uncommitted-changes-message "Uncommitted changes"
	)
	(global-blamer-mode t)
)

(use-package centaur-tabs
	:ensure t
	:demand
	:config
	(setq centaur-tabs-style "bar"
			centaur-tabs-set-bar 'over
			centaur-tabs-set-icons t
			centaur-tabs-height 25
			centaur-tabs-show-new-tab-button nil
	)
	(centaur-tabs-change-fonts (face-attribute 'default :font) 110)
	(centaur-tabs-headline-match)
	(centaur-tabs-mode t)
	:bind
	("C-x <prior>" . centaur-tabs-backward)
	("C-x <next>" . centaur-tabs-forward)
	:hook
	(dashboard-mode . centaur-tabs-local-mode)
)

(use-package emojify
	:ensure t
	:defer t
	:hook (after-init . global-emojify-mode)
)

(provide 'ui-config)
