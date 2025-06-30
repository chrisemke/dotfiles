(add-to-list 'load-path (locate-user-emacs-file "config/"))
(setq custom-file (locate-user-emacs-file "custom.el"))

(require 'packages-config)
(require 'behaviour-config)
(require 'code-config)
(require 'git-config)
(require 'keys-config)
(require 'ui-config)

(provide 'init)
