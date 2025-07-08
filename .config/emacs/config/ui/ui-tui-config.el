(unless (display-graphic-p)
	(xterm-mouse-mode t)
)

(use-package centaur-tabs
	:custom
	(centaur-tabs-icon-type 'nerd-icons)
	:unless (display-graphic-p)
)

(use-package treemacs-nerd-icons
	:after (treemacs)
	:config
	(treemacs-load-theme "nerd-icons")
	:ensure t
	:unless (display-graphic-p)
)

(use-package lsp-treemacs
	:custom
	(lsp-treemacs-theme "nerd-icons")
	:unless (display-graphic-p)
)

(provide 'ui-tui-config)
