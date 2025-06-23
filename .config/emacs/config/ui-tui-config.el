(unless (display-graphic-p)
	(xterm-mouse-mode t)
	(setq centaur-tabs-icon-type 'nerd-icons)
)

(use-package treemacs-nerd-icons
	:after (treemacs)
	:config
	(treemacs-load-theme "nerd-icons")
	:ensure t
	:unless (display-graphic-p)
)

(provide 'ui-tui-config)
