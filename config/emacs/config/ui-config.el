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
	(scroll-bar-mode 0)
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

;; (use-package nerd-icons-dired
;; 	:commands (nerd-icons-dired-mode)
;; 	:ensure t
;; 	:hook (dired-mode . nerd-icons-dired-mode)
;; 	)

;; (defun my/dired-sidebar-subtree-toggle-or-open ()
;; 	"On Enter: expand/collapse directories or open files in dirvish."
;; 	(interactive)
;; 	(let ((file (dired-get-filename nil t)))
;; 		(if (and file (file-directory-p file))
;; 				(dired-sidebar-subtree-toggle)
;; 			;; Otherwise open the file like normal `find-file`
;; 			(dired-sidebar-find-file)))
;; 	)

;; (use-package dired-sidebar
;;   :bind (("C-b" . dired-sidebar-toggle-sidebar)
;; 				 ("<return>" . my/dired-sidebar-subtree-toggle-or-open))
;;   :ensure t
;;   :commands (dired-sidebar-toggle-sidebar)
;;   :config
;; 	(push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
;; 	(push 'rotate-windows dired-sidebar-toggle-hidden-commands)
;; 	:custom
;; 	(dired-sidebar-subtree-line-prefix "  |")
;; 	(dired-sidebar-theme 'nerd-icons)
;; 	(dired-sidebar-use-custom-font t)
;; 	(dired-sidebar-should-follow-file t)
;; 	(dired-sidebar-display-remote-icons t)
;; 	:hook
;; 	(dired-sidebar-mode . (lambda ()
;; 													(unless (file-remote-p default-directory)
;; 														(auto-revert-mode))
;; 													(whitespace-mode 0)
;; 													(display-line-numbers-mode 0)))
;; 	)


(use-package dired
	:custom
	(dired-use-ls-dired t)
	(dired-listing-switches
	 "-l --almost-all --group-directories-first --human-readable --no-group")
	)

(defun my/dirvish-subtree-toggle-or-open ()
	"On Enter: expand/collapse directories or open files in dirvish."
	(interactive)
	(let ((file (dired-get-filename nil t)))
		(if (and file (file-directory-p file))
				(dirvish-subtree-toggle)
			;; Otherwise open the file like normal `find-file`
			(dired-find-file)))
	)

(use-package dirvish
	:bind
	(("C-c f" . dirvish)
	 ("C-b" . dirvish-side)
	 :map dirvish-mode-map
	 ("<mouse-1>" . dirvish-subtree-toggle-or-open)
	 ("<mouse-2>" . nil)
	 ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
	 ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
	 ("TAB" . dirvish-subtree-toggle)
	 ("<RET>" . my/dirvish-subtree-toggle-or-open))
	:config
	(dirvish-side-follow-mode t)
	:custom
	(dired-mouse-drag-files t)
	(mouse-drag-and-drop-region-cross-program t)
	(mouse-1-click-follows-link nil)
	(dirvish-attributes '(vc-state subtree-state nerd-icons))
	(dirvish-mode-line-format '(:left (vc-info) :right (yank index)))
	:ensure t
	:hook
	(dired-mode . (lambda ()
									(display-line-numbers-mode 0)
									(whitespace-mode 0)))
	:init
	(dirvish-override-dired-mode)
	)

(with-eval-after-load 'vc-hooks
	;; Modified → orange
	(set-face-attribute 'vc-edited-state nil
											:foreground "#e5a50a"
											:weight 'medium)

	;; Added → green
	(set-face-attribute 'vc-locally-added-state nil
											:foreground "#40a02b"
											:weight 'medium)

	;; Removed → red
	(set-face-attribute 'vc-removed-state nil
											:foreground "#d20f39")

	;; Needs update
	(set-face-attribute 'vc-needs-update-state nil
											:foreground "#df8e1d")
	)


(with-eval-after-load 'dirvish
	;; Ignored → very dark
	(defface dirvish-vc-ignored-state
		'((t (:inherit shadow)))
		"Face for ignored files in Dirvish."
		:group 'dirvish)

	;; Untracked → subtle (no VC face exists!)
	(defface dirvish-vc-untracked-state
		'((t (:inherit vc-locally-added-state)))
		"Face for untracked files in Dirvish."
		:group 'dirvish)

	;; VC → face mapping
	(setq dirvish-vc-state-face-alist
				'((up-to-date       . nil)
					(edited           . dirvish-vc-edited-state)
					(added            . vc-locally-added-state)
					(removed          . vc-removed-state)
					(missing          . vc-missing-state)
					(needs-merge      . vc-conflict-state)
					(conflict         . vc-conflict-state)
					(unlocked-changes . vc-locked-state)
					(needs-update     . vc-needs-update-state)
					(ignored          . dirvish-vc-ignored-state)
					(unregistered     . dirvish-vc-untracked-state)))
	)

(use-package diff-hl
	:after magit
	:config (diff-hl-flydiff-mode t)
	:ensure t
	:hook ((magit-post-refresh . diff-hl-magit-post-refresh)
				 (vc-checkin         . diff-hl-update))
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
	:ensure t
	:config (breadcrumb-mode t)
	:custom
	(breadcrumb-imenu-crumb-separator
	 (concat " "(nerd-icons-mdicon "nf-md-chevron_right") " "))
	(breadcrumb-project-crumb-separator
	 (concat " "(nerd-icons-mdicon "nf-md-chevron_right") " "))
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
