(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(editorconfig-mode t)

(use-package projectile
	:ensure t
	:init
	(setq projectile-project-search-path '("~/"))
	:config
	(projectile-mode t)
)

(use-package yaml-mode
	:ensure t
	:hook ((yaml-mode yaml-ts-mode) . (lambda ()
															(setq-local indent-tabs-mode nil)
															(setq-local yaml-indent-offset 2)
														)
			)
)

(provide 'packages)
