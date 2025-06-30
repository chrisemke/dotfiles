(when (display-graphic-p)
	(tool-bar-mode 0)
	(scroll-bar-mode 0)
	(set-face-attribute 'default nil
											:font "OpenDyslexicM Nerd Font Mono"
											:height 120
	)
	(setq centaur-tabs-icon-type 'all-the-icons)
)

(use-package all-the-icons
	:ensure t
	:when (display-graphic-p)
)

(use-package treemacs-all-the-icons
	:after (treemacs all-the-icons)
	:config
	(treemacs-load-theme "all-the-icons")
	:ensure t
	:when (display-graphic-p)
)

(provide 'ui-gui-config)
