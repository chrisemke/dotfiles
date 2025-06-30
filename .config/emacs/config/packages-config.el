(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(use-package projectile
	:config
	(projectile-mode t)
	:custom
	(projectile-project-search-path '("~/"))
	:ensure t
)

(use-package yaml-mode
	:ensure t
	:hook
	((yaml-mode yaml-ts-mode) . (lambda ()
																(setq-local indent-tabs-mode nil)
																(setq-local yaml-indent-offset 2)
															)
	)
)

(provide 'packages-config)
