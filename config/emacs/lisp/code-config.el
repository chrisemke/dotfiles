;; -*- lexical-binding: t; -*-
(use-package magit
	:after (nerd-icons)
	:bind
	("C-c m s" . magit-status)
	("C-c m l" . magit-log)
	:custom (magit-format-file-function #'magit-format-file-nerd-icons)
	:defer t
	:ensure t)

(use-package vc
	:ensure nil
	:custom (vc-auto-revert-mode t))

;; Do not install mason when using Guix.
(unless (with-temp-buffer
					(when (file-exists-p "/etc/os-release")
						(insert-file-contents "/etc/os-release")
						(re-search-forward "^ID=guix$" nil t)))
	(use-package mason
		:config
		(mason-setup)
		(defun my/mason-install-all ()
			"Intall all LSPs/linters based on a list preset"
			(interactive)
			(dolist (pkg '("rassumfrassum" "zuban" "ruff" "typos-lsp" "rust-analyzer" "elixir-ls"))
				(unless (mason-installed-p pkg)
					(ignore-errors (mason-install pkg)))))
		:ensure t))

(use-package prog-mode
	:ensure nil
	:bind
	(:map prog-mode-map
				("C-c e f" . (lambda ()
											 (interactive)
											 (indent-region (point-min) (point-max))))))

(use-package eglot
	:bind
	(:map eglot-mode-map
				("C-." . eglot-code-actions)
				("C-c e f" . eglot-format-buffer))
	:custom
	(eglot-autoshutdown t)
	(eglot-code-action-indications nil)
	(eldoc-echo-area-use-multiline-p nil)
	(eldoc-display-functions '(eldoc-display-in-buffer))
	(eglot-documentation-renderer 'markdown-ts-view-mode)
	:ensure nil
	:hook (eglot-managed-mode . (lambda () (eglot-inlay-hints-mode 0))))

(use-package flymake
	:custom (flymake-fringe-indicator-position nil)
	:ensure nil)

(use-package dape
	:custom
	(dape-buffer-window-arrangement 'right)
	(dape-request-timeout 60)
	:ensure t)

(use-package dockerfile-mode
	:defer t
	:ensure t)

(use-package yaml-mode
	:defer t
	:ensure t
	:hook
	(yaml-ts-mode . (lambda ()
										(setq-local indent-tabs-mode nil)
										(setq-local yaml-indent-offset 2))))

(use-package fish-mode
	:defer t
	:ensure t)

;;; ============================================================================
;;; JSON
;;; ============================================================================

(use-package json
	:ensure nil
	:hook
	(json-ts-mode . (lambda ()
										(keymap-local-set "C-c e f" #'json-pretty-print-buffer))))

;;; ============================================================================
;;; ELIXIR
;;; ============================================================================

(use-package eglot
	:config
	(add-to-list 'eglot-server-programs
							 '(elixir-ts-mode . ("rass" "--" "elixir-ls" "--" "typos-lsp")))
	:ensure nil
	:hook (elixir-ts-mode . eglot-ensure))


;;; ============================================================================
;;; PYTHON
;;; ============================================================================

(use-package eglot
	:config
	(add-to-list 'eglot-server-programs
							 '(python-ts-mode . ("rass"
																	 "--"
																	 "zuban"
																	 "server"
																	 "--"
																	 "ruff"
																	 "server"
																	 "--"
																	 "typos-lsp")))
	:ensure nil
	:hook (python-ts-mode . eglot-ensure))

(use-package python
	:ensure nil
	:hook
	(python-ts-mode . (lambda ()
											(setq-local indent-tabs-mode t
																	tab-width 2
																	python-indent-offset 2)
											(python-indent-guess-indent-offset)
											(setq-local tab-width python-indent-offset)
											(dtrt-indent-mode 0)
											(dtrt-indent-mode t))))

;; Colors to uv.lock
(use-package toml-ts-mode
	:ensure nil
	:mode ("uv\\.lock" . toml-ts-mode))


;;; ============================================================================
;;; RUST
;;; ============================================================================

(use-package eglot
	:config
	(add-to-list 'eglot-server-programs
							 '(rust-ts-mode . ("rass" "--" "rust-analyzer" "--" "typos-lsp")))
	(setq-default eglot-workspace-configuration
								(plist-put (copy-sequence
														(default-value 'eglot-workspace-configuration))
													 :rust-analyzer
													 '(:check (:command "clippy")
																		:cargo (:targetDir t))))
	:ensure nil
	:hook (rust-ts-mode . eglot-ensure))

(use-package rust-ts-mode
	:ensure nil
	:hook
	(rust-ts-mode . (lambda ()
										(setq-local indent-tabs-mode t
																tab-width 2
																rust-ts-mode-indent-offset 2)
										(dtrt-indent-mode 0)
										(dtrt-indent-mode t))))

;; Colors to Cargo.lock
(use-package toml-ts-mode
	:ensure nil
	:mode ("Cargo\\.lock" . toml-ts-mode))


;;; ============================================================================
;;; GUILE
;;; ============================================================================

(use-package geiser-guile
	:custom (geiser-mode-start-repl-p t)
	:defer t
	:ensure t)

(provide 'code-config)
