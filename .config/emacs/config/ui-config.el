(use-package catppuccin-theme
	:config
	(load-theme 'catppuccin t)
	:custom
	(catppuccin-flavor 'mocha)
	:ensure t
)

(use-package nerd-icons-completion
	:after marginalia
	:ensure t
	:hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
	:init (nerd-icons-completion-mode)
)

(use-package nerd-icons-corfu
	:after corfu
	:config (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
	:ensure t
)

(when (display-graphic-p)
	(scroll-bar-mode 0)
	(set-face-attribute 'default nil
											:font "OpenDyslexicM Nerd Font Mono"
											:height 120
	)
)

(unless (display-graphic-p)
	(xterm-mouse-mode t)
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
(blink-cursor-mode 0)

(use-package solaire-mode
	:config (solaire-global-mode t)
	:ensure t
)

(use-package whitespace
	:config (global-whitespace-mode)
	:custom
	(whitespace-style '(face tabs spaces trailing space-mark tab-mark))
	(whitespace-display-mappings '((space-mark ?\  [?·])
																 (tab-mark ?\t [?→ ?\t])
																)
	)
	:ensure nil
	:hook (prog-mode . global-whitespace-mode)
)

(use-package doom-modeline
	:custom (doom-modeline-indent-info t)
	:ensure t
	:init (doom-modeline-mode t)
)

(use-package dashboard
	:config (dashboard-setup-startup-hook)
	:custom
	(dashboard-startupify-list '(dashboard-insert-banner
															 dashboard-insert-newline
															 dashboard-insert-init-info
															 dashboard-insert-items
															)
	)
	(dashboard-startup-banner (if (display-graphic-p) 'logo 2))
	(dashboard-center-content t)
	(dashboard-vertically-center-content t)
	(dashboard-set-file-icons t)
	(dashboard-display-icons-p t)
	(dashboard-icon-type 'nerd-icons)
	(dashboard-projects-backend 'projectile)
	:ensure t
)

(use-package treemacs
	:bind ("C-b" . treemacs)
	:config
	(treemacs-follow-mode t)
	(treemacs-git-mode 'deferred)
	(treemacs-indent-guide-mode t)
	(treemacs-filewatch-mode t)
	(with-eval-after-load 'treemacs
		(define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
	)
	:ensure t
	:hook (treemacs-mode . (lambda () (display-line-numbers-mode 0)))
)

(use-package treemacs-nerd-icons
	:after (treemacs)
	:config (treemacs-load-theme "nerd-icons")
	:ensure t
)

(use-package treemacs-projectile
	:after (treemacs projectile)
	:config (treemacs-project-follow-mode t)
	:ensure t
)

(use-package treemacs-magit
	:after (treemacs magit)
	:config (treemacs-git-commit-diff-mode)
	:ensure t
)

(use-package diff-hl
	:after magit
	:config
	(diff-hl-flydiff-mode)
	(diff-hl-margin-mode)
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
	(centaur-tabs-icon-type 'nerd-icons)
	(centaur-tabs-show-new-tab-button nil)
	:demand
	:ensure t
	:hook (dashboard-mode . centaur-tabs-local-mode)
)

(use-package emojify
	:defer t
	:ensure t
	:hook (after-init . global-emojify-mode)
)

(provide 'ui-config)
