(use-package magit
	:after (nerd-icons)
	:custom (magit-format-file-function #'magit-format-file-nerd-icons)
	:ensure t
	)

(use-package magit-todos
	:after magit
	:config (magit-todos-mode t)
	:ensure t
	)

(use-package mason
	:config
	(mason-ensure
	 (lambda ()
		 (dolist (pkg '("zuban" "ruff" "elixir-ls"))
			 (unless (mason-installed-p pkg)
				 (ignore-errors (mason-install pkg))))))
	:ensure t
	)

(use-package eglot
	:bind (("C-." . eglot-code-actions))
	:config
	(define-key eglot-mode-map (kbd "M-F")
							(lambda ()
								(interactive)
								(if (derived-mode-p 'python-base-mode)
										(lazy-ruff-lint-format-dwim)
									(eglot-format-buffer))))
	:custom (eglot-autoshutdown t)
	:ensure nil
	)

;; TODO: Replace dap-mode with dape
(use-package dap-mode
	:after lsp-mode
	:bind (("<f5>" . dap-debug)
				 ("S-<f5>" . dap-disconnect))
	:config (require 'dap-python)
	:ensure t
	)

(use-package dockerfile-mode
	:defer t
	:ensure t
	)

(use-package projectile
	:config
	(projectile-mode t)
	(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
	:custom (projectile-project-search-path '("~/"))
	:ensure t
	)

(use-package yaml-mode
	:defer t
	:ensure t
	:hook (yaml-ts-mode . (lambda ()
													(setq-local indent-tabs-mode nil)
													(setq-local yaml-indent-offset 2)
													)
											)
	)

;;; ============================================================================
;;; JSON
;;; ============================================================================

(use-package json
	:config
	(eval-after-load 'json-ts-mode
		'(progn
			 (define-key json-ts-mode-map (kbd "M-F") #'json-pretty-print-buffer)))
	:ensure nil
	:hook (json-ts-mode . (lambda () (add-hook 'before-save-hook #'json-pretty-print-buffer)))
	)

;;; ============================================================================
;;; ELISP
;;; ============================================================================

(add-hook 'emacs-lisp-mode-hook
					(lambda ()
						(add-hook 'before-save-hook (lambda () (indent-region (point-min) (point-max))) nil t)
						))

;;; ============================================================================
;;; ELIXIR
;;; ============================================================================

;; Not covered by treesit-auto
(use-package elixir-ts
	:mode ("\\.exs\\'" . elixir-ts-mode)
	)

(use-package eglot
	:config (add-to-list 'eglot-server-programs
											 '((elixir-mode elixir-ts-mode) . ("elixir-ls")))
	:ensure nil
	:hook (elixir-ts-mode . eglot-ensure)
	)

;;; ============================================================================
;;; PYTHON
;;; ============================================================================

(use-package eglot
	:config (add-to-list 'eglot-server-programs
											 '(python-base-mode . ("zuban" "server"))
											 )
	:ensure nil
	:hook (python-base-mode . (lambda ()
															(eglot-ensure)))
	)

(use-package flymake-ruff
	:ensure t
	:custom (python-flymake-command nil)
	:hook (eglot-managed-mode . flymake-ruff-load)
	)

(use-package lazy-ruff
  :ensure t
  :config (lazy-ruff-global-mode t)
	)

(use-package dap-python
	:config (dap-auto-configure-mode t)
	:custom (dap-python-debugger 'debugpy)
	:hook (python-ts-mode . (lambda ()
														(dap-ui-mode t)
														(dap-mode t)
														))
	)

(use-package auto-virtualenv
	:ensure t
	:config (auto-virtualenv-setup)
	:custom (auto-virtualenv-reload-lsp t)
	)

(use-package python
	:ensure nil
	:hook
	(python-ts-mode . (lambda ()
											(setq-local indent-tabs-mode t)
											(setq-local tab-width 2)
											(setq-local python-indent-offset 2)
											(python-indent-guess-indent-offset)
											(setq-local tab-width python-indent-offset)
											(dtrt-indent-mode 0)
											(dtrt-indent-mode t)
											))
	)


;;; ============================================================================
;;; GUILE
;;; ============================================================================

(use-package geiser-guile
	:ensure t
	)

(provide 'code-config)
