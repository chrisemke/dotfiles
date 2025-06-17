(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package)
)

(use-package editorconfig
	:ensure t
	:config
	(editorconfig-mode 1)
)

(use-package projectile
	:ensure t
	:init
	(setq projectile-project-search-path '("~/"))
	:config
	(projectile-mode t)
)

(use-package toml-mode
  :ensure t
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
