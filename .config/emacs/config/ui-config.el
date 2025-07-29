(add-to-list 'load-path (locate-user-emacs-file "config/ui/"))

(require 'ui-gui-config)
(require 'ui-tui-config)

(use-package catppuccin-theme
	:config
	(load-theme 'catppuccin t)
	:custom
	(catppuccin-flavor 'mocha)
	:ensure t
)

(setq inhibit-startup-screen t
	inhibit-startup-message t
	initial-scratch-message nil
	frame-resize-pixelwise t
)

(setq-default cursor-type 'bar
	tab-width 2
)

(global-display-line-numbers-mode t)
(column-number-mode t)

(use-package whitespace
	:custom
	(whitespace-style '(face tabs spaces trailing space-mark tab-mark))
	(whitespace-display-mappings '((space-mark ?\  [?·])
			(tab-mark ?\t [?→ ?\t])
		)
	)
	:ensure nil
	:hook
	(prog-mode . global-whitespace-mode)
)

(use-package treemacs
	:bind
	("C-b" . treemacs)
	:config
	(treemacs-follow-mode t)
	(treemacs-git-mode 'deferred)
	(treemacs-indent-guide-mode t)
	(treemacs-filewatch-mode t)
	:ensure t
	:hook (treemacs-mode . (lambda () (display-line-numbers-mode 0)))
)

(use-package treemacs-projectile
	:after (treemacs projectile)
	:config (treemacs-project-follow-mode t)
	:ensure t
)

(use-package treemacs-magit
	:after (treemacs magit)
	:ensure t
)

(use-package diff-hl
	:after magit
	:config (diff-hl-flydiff-mode)
	:ensure t
	:hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
				 (magit-post-refresh . diff-hl-magit-post-refresh)
				 (vc-checkin         . diff-hl-update)
				)
	:init (global-diff-hl-mode)
)

(use-package centaur-tabs
	:bind
	("C-x <prior>" . centaur-tabs-backward)
	("C-x <next>" . centaur-tabs-forward)
	:config
	(centaur-tabs-change-fonts (face-attribute 'default :font) 130)
	(centaur-tabs-headline-match)
	(centaur-tabs-mode t)
	:custom
	(centaur-tabs-style "bar")
	(centaur-tabs-set-bar 'over)
	(centaur-tabs-set-icons t)
	(centaur-tabs-height 25)
	(centaur-tabs-show-new-tab-button nil)
	:demand
	:ensure t
	:hook
	(dashboard-mode . centaur-tabs-local-mode)
)

(use-package emojify
	:defer t
	:ensure t
	:hook (after-init . global-emojify-mode)
)

(provide 'ui-config)
