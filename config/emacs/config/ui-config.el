(use-package catppuccin-theme
	:config
	(load-theme 'catppuccin t)
	:ensure t
	)

(use-package nerd-icons
	:custom (nerd-icons-font-family "OpenDyslexicM Nerd Font Mono")
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
	(set-face-attribute 'default nil
											:font "OpenDyslexicM Nerd Font Mono"
											:height 150
											)
	(toggle-frame-maximized)
	(set-frame-parameter nil 'internal-border-width 0) ;; MACOS ONLY
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
	:config (solaire-global-mode)
	:ensure t
	)

(use-package whitespace
	:custom
	(whitespace-style '(face tabs spaces trailing space-mark tab-mark))
	(whitespace-display-mappings '((space-mark ?\  [?·])
																 (tab-mark ?\t [?→ ?\t])
																 )
															 )
	:ensure nil
	;; :hook (prog-mode . whitespace-mode)
	)

(use-package indent-bars
	:config (add-hook 'prog-mode-hook #'indent-bars-mode 1)
	:custom
	(indent-bars-treesit-support t)
	(indent-bars-treesit-wrap '((python argument_list parameters
																			list list_comprehension
																			dictionary dictionary_comprehension
																			parenthesized_expression subscript)
															(toml table array comment)
															(yaml block_mapping_pair comment)
															(rust arguments parameters)
															(c argument_list parameter_list init_declarator parenthesized_expression)))
	(indent-bars-treesit-scope '((rust trait_item impl_item
																		 macro_definition macro_invocation
																		 struct_item enum_item mod_item
																		 const_item let_declaration
																		 function_item for_expression
																		 if_expression loop_expression
																		 while_expression match_expression
																		 match_arm call_expression
																		 token_tree token_tree_pattern
																		 token_repetition)))
	(indent-bars-treesit-ignore-blank-lines-types '("module"))
	(indent-bars-color '(highlight :face-bg t :blend 0.15))
	(indent-bars-pattern ".")
	(indent-bars-width-frac 0.1)
	(indent-bars-pad-frac 0.1)
	(indent-bars-zigzag nil)
	(indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1)) ; blend=1: blend with BG only
	(indent-bars-highlight-current-depth '(:blend 0.5)) ; pump up the BG blend on current
	(indent-bars-display-on-blank-lines t)
	(indent-bars-starting-column 0)
	:ensure t
	)

(use-package doom-modeline
	:custom
	(doom-modeline-indent-info t)
	(auto-revert-check-vc-info t)
	(doom-modeline-height 15)
	(doom-modeline-vcs-max-length 25)
	(doom-modeline-major-mode-icon nil)
	(doom-modeline-buffer-file-name-style 'file-name-with-project)
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
	(dashboard-items '((recents   . 10)
										 (projects  . 5)))
	(dashboard-startup-banner (if (display-graphic-p) 'logo 2))
	(dashboard-center-content t)
	(dashboard-vertically-center-content t)
	(dashboard-set-heading-icons t)
	(dashboard-set-file-icons t)
	(dashboard-display-icons-p t)
	(dashboard-icon-type 'nerd-icons)
	:ensure t
	)

(use-package nerd-icons-dired
	:ensure t
	:hook (dired-mode . nerd-icons-dired-mode)
	)

(use-package diff-hl
	:config (diff-hl-flydiff-mode t)
	:defer t
	:ensure t
	:hook ((magit-post-refresh . diff-hl-magit-post-refresh)
				 (vc-checkin         . diff-hl-update)
				 (dired-mode         . diff-hl-dired-mode))
	:init (global-diff-hl-mode)
	)

(use-package centaur-tabs
	:bind
	("C-x <prior>" . centaur-tabs-backward)
	("C-x <next>" . centaur-tabs-forward)
	:config
	(centaur-tabs-change-fonts (face-attribute 'default :font) 160)
	(centaur-tabs-headline-match)
	(centaur-tabs-mode t)
	:custom
	(centaur-tabs-style "chamfer")
	(centaur-tabs-set-icons t)
	(centaur-tabs-height 25)
	(centaur-tabs-icon-type 'nerd-icons)
	(centaur-tabs-show-new-tab-button nil)
	:demand
	:ensure t
	:hook (dashboard-mode . centaur-tabs-local-mode)
	)

(use-package breadcrumb
	:config (breadcrumb-mode t)
	:custom
	(breadcrumb-imenu-crumb-separator
	 (concat " "(nerd-icons-mdicon "nf-md-chevron_right") " "))
	(breadcrumb-project-crumb-separator
	 (concat " "(nerd-icons-mdicon "nf-md-chevron_right") " "))
	:ensure t
	:preface
	;; Add icons to breadcrumb
	(advice-add #'breadcrumb--format-project-node :around
							(lambda (og p more &rest r)
								"Icon For File"
								(let ((string (apply og p more r)))
									(if (not more)
											(concat (nerd-icons-icon-for-file string)
															" " string)
										(concat (nerd-icons-faicon
														 "nf-fa-folder_open"
														 :face 'breadcrumb-project-crumbs-face)
														" "
														string)))))
	)

(add-hook 'prog-mode-hook (lambda ()
														(display-fill-column-indicator-mode t)
														(setopt display-fill-column-indicator-column 80))
					)


(provide 'ui-config)
