(require 'package)

(use-package magit
	:after (nerd-icons)
	:custom (magit-format-file-function #'magit-format-file-nerd-icons)
	:ensure t
)

(provide 'git-config)
