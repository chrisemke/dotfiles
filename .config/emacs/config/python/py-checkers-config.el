(use-package lsp-pyright
	:after lsp-mode
	:ensure t
	:hook ((python-mode python-ts-mode) . (lambda ()
																					(require 'lsp-pyright)
																					(lsp-deferred))
				)
)

(flycheck-define-checker python-ruff
	"Check Python code with Ruff."
	:command ("ruff" "check" "--stdin-filename" source-original "-")
	:error-patterns
	((warning line-start (file-name) ":" line ":" (optional column ":") " " (id (one-or-more (any alpha digit))) " " (message) line-end))
	:modes (python-mode python-ts-mode)
	:standard-input t
)

(flycheck-define-checker python-dmypy
	"Type check Python code using dmypy."
	:command ("dmypy" "check" source)
	:error-patterns
	((error line-start (file-name) ":" line ": error: " (message) line-end))
	:modes (python-mode python-ts-mode)
)

(provide 'py-checkers-config)
