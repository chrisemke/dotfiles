(use-package lsp-mode
	:bind ("C-." . lsp-execute-code-action)
	:commands (lsp lsp-deferred)
	:custom
	(lsp-keymap-prefix "C-c l")
	(lsp-auto-configure t)
	:ensure t
	:hook (lsp-mode . lsp-enable-which-key-integration)
	)

(use-package lsp-diagnostics
	:after flycheck
	:config (lsp-diagnostics-flycheck-enable)
	)

(use-package lsp-ui
	:commands lsp-ui-mode
	:custom (lsp-ui-doc-show-with-cursor t)
	:ensure t
	)

(use-package lsp-treemacs
	:commands lsp-treemacs-errors-list
	:config (lsp-treemacs-sync-mode t)
	:ensure t
	:init (setq lsp-treemacs-theme "nerd-icons")
	)

(use-package dap-mode
	:after lsp-mode
	:ensure t
	)

(use-package flycheck
	:ensure t
	:init (global-flycheck-mode)
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
	:hook ((yaml-mode yaml-ts-mode) . (lambda ()
																			(setq-local indent-tabs-mode nil)
																			(setq-local yaml-indent-offset 2)
																			)
				 )
	)

;;; ============================================================================
;;; ELISP
;;; ============================================================================

(defun my/indent-elisp-buffer ()
  "Indent the entire Emacs Lisp buffer."
  (when (eq major-mode 'emacs-lisp-mode)
    (indent-region (point-min) (point-max))))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'my/indent-elisp-buffer nil t)))

;;; ============================================================================
;;; PYTHON
;;; ============================================================================

(use-package lsp-mode
	:custom
	(lsp-ruff-server-command "")
	(lsp-pylsp-plugins-ruff-enabled t)
	(lsp-pylsp-plugins-mypy-enabled t)
	;; (lsp-pylsp-plugins-mypy-dmypy t)
	(lsp-pylsp-plugins-mypy-report-progress t)
	(lsp-pylsp-plugins-flake8-enabled nil)
	(lsp-pylsp-plugins-pydocstyle-enabled nil)
	:hook ((python-mode python-ts-mode) . lsp-deferred)
	)

(use-package dap-python
	:config (dap-auto-configure-mode t)
	:custom (dap-python-debugger 'debugpy)
	:hook (((python-mode python-ts-mode) . dap-ui-mode)
				 ((python-mode python-ts-mode) . dap-mode)
				 )
	)

(defun my/python-tab-setup ()
	"Ensure Python uses literal tabs and proper visual width."
	(dtrt-indent-mode t)
	(setq-local tab-width 2)

	(when indent-tabs-mode
		(setq-local indent-line-function #'tab-to-tab-stop)
		)

	(unless indent-tabs-mode
		(setq-local python-indent-offset standard-indent)
		)
	)

(add-hook 'python-ts-mode-hook #'my/python-tab-setup)
(add-hook 'python-mode-hook #'my/python-tab-setup)


;;; ============================================================================
;;; GUILE
;;; ============================================================================

(use-package geiser-guile
	:ensure t
	)

(provide 'code-config)
