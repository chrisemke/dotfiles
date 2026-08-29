;; -*- lexical-binding: t; -*-
(use-package batppuccin
	:config (load-theme 'batppuccin-mocha t)
	:ensure t
	:if (display-graphic-p))

(use-package nerd-icons
	:custom (nerd-icons-font-family "OpenDyslexicM Nerd Font Mono")
	:ensure t)

(use-package nerd-icons-completion
	:after marginalia
	:ensure t
	:hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
	:init (nerd-icons-completion-mode))

;; Setup ibuffer
(use-package nerd-icons-ibuffer
	:defer t
	:ensure t
	:hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package ibuffer
	:bind
	(:map ibuffer-name-map
				("<mouse-1>" . ibuffer-visit-buffer))
	:custom
	(ibuffer-saved-filter-groups
	 '(("my/custom-default"
			("Code" (derived-mode . prog-mode))
			("Conf" (derived-mode . conf-mode))
			("Markup" (or (mode . org-mode)
										(derived-mode . markdown-mode)))
			("Shell" (mode . eshell-mode))
			("Directories" (mode . dired-mode))
			("Git" (or (derived-mode . magit-mode)
								 (mode . vc-compilation-mode))))))
	(ibuffer-show-empty-filter-groups nil)
	(ibuffer-human-readable-size t)
	:defer t
	:ensure nil
	:hook
	(ibuffer-mode . (lambda ()
										(ibuffer-switch-to-saved-filter-groups "my/custom-default"))))

(when (display-graphic-p)
	(set-face-attribute 'default nil
											:font "OpenDyslexicM Nerd Font Mono"
											:height 130)
	(toggle-frame-maximized)
	(when (eq system-type 'darwin)
		(set-frame-parameter nil 'internal-border-width 0)))

(setopt inhibit-startup-screen t
				inhibit-startup-message t
				initial-scratch-message nil
				frame-resize-pixelwise t
				cursor-type 'bar)

(global-display-line-numbers-mode t)
(column-number-mode t)
(blink-cursor-mode 0)

(use-package solaire-mode
	:config (solaire-global-mode)
	:ensure t
	:hook (dashboard-mode . turn-off-solaire-mode)
	:if (display-graphic-p))

(use-package whitespace
	:custom
	(whitespace-style '(face tabs spaces trailing space-mark tab-mark))
	(whitespace-display-mappings '((space-mark ?\  [?·])
																 (tab-mark ?\t [?→ ?\t])))
	:ensure nil)

(use-package doom-modeline
	:custom
	(doom-modeline-indent-info t)
	(auto-revert-check-vc-info t)
	(doom-modeline-height 15)
	(doom-modeline-vcs-max-length 25)
	(doom-modeline-major-mode-icon nil)
	(doom-modeline-buffer-file-name-style 'project)
	:defer t
	:ensure t
	:init (doom-modeline-mode t))

(use-package dashboard
	:config (dashboard-setup-startup-hook)
	:custom
	(dashboard-startupify-list '(dashboard-insert-banner
															 dashboard-insert-newline
															 dashboard-insert-init-info
															 dashboard-insert-items))
	(dashboard-items '((recents   . 10)
										 (projects  . 5)))
	(dashboard-startup-banner (locate-user-emacs-file "banners/banner.txt"))
	(dashboard-center-content t)
	(dashboard-vertically-center-content t)
	(dashboard-set-heading-icons t)
	(dashboard-set-file-icons t)
	(dashboard-display-icons-p t)
	(dashboard-icon-type 'nerd-icons)
	:ensure t)

(use-package nerd-icons-dired
	:defer t
	:ensure t
	:hook (dired-mode . nerd-icons-dired-mode))

(use-package diff-hl
	:config (diff-hl-flydiff-mode t)
	:custom
	(diff-hl-update-async t)
	(vc-git-diff-switches '("--histogram"))
	:ensure t
	:hook ((after-init         . global-diff-hl-mode)
				 (magit-post-refresh . diff-hl-magit-post-refresh)
				 (vc-checkin         . diff-hl-update)
				 (dired-mode         . diff-hl-dired-mode)))

(use-package breadcrumb
	:config (breadcrumb-mode t)
	:custom
	(breadcrumb-imenu-crumb-separator
	 (concat " " (nerd-icons-mdicon "nf-md-chevron_right") " "))
	(breadcrumb-project-crumb-separator
	 (concat " " (nerd-icons-mdicon "nf-md-chevron_right") " "))
	:ensure t)

(setopt display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(provide 'ui-config)
