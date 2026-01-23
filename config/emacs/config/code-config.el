(use-package magit
	:after (nerd-icons)
	:custom (magit-format-file-function #'magit-format-file-nerd-icons)
	:ensure t
	)

(use-package mason
	:config
	(mason-ensure
	 (lambda ()
		 (dolist (pkg '("rassumfrassum" "zuban" "ruff" "typos-lsp" "elixir-ls"))
			 (unless (mason-installed-p pkg)
				 (ignore-errors (mason-install pkg))))))
	:ensure t
	)

(use-package eglot
	:bind (("C-." . eglot-code-actions))
	:config
	(define-key eglot-mode-map (kbd "M-F") (lambda ()
																					 (interactive)
																					 (eglot-format-buffer)))
	:custom (eglot-autoshutdown t)
	:ensure nil
	)

(use-package flymake
	:custom (flymake-fringe-indicator-position nil)
	:ensure nil
	)

(use-package dape
	:custom
	(dape-buffer-window-arrangement 'right)
	(dape-request-timeout 60)
	:ensure t
	)

(use-package dockerfile-mode
	:defer t
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

(use-package fish-mode
	:ensure t
	)

;;; ============================================================================
;;; JSON
;;; ============================================================================

(use-package json
	:ensure nil
	:hook
	(json-ts-mode . (lambda ()
										(local-set-key (kbd "M-F") #'json-pretty-print-buffer)))
	)

;;; ============================================================================
;;; ELISP
;;; ============================================================================

(add-hook 'emacs-lisp-mode-hook
					(lambda ()
						(local-set-key (kbd "M-F") (lambda ()
																				 (interactive)
																				 (indent-region (point-min) (point-max)))))
					)


;;; ============================================================================
;;; ELIXIR
;;; ============================================================================

;; Not covered by treesit-auto
(use-package elixir-ts
	:mode ("\\.exs" . elixir-ts-mode)
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
											 '(python-base-mode . ("rass" "--" "zuban" "server" "--" "ruff" "server" "--" "typos-lsp"))
											 )
	:ensure nil
	:hook (python-base-mode . eglot-ensure)
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


;; Colors to uv.lock
(use-package toml-ts
	:mode ("uv\\.lock" . toml-ts-mode)
	)

;;; ============================================================================
;;; GUILE
;;; ============================================================================

(use-package geiser-guile
	:ensure t
	)

(provide 'code-config)
