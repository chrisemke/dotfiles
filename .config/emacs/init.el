(add-to-list 'load-path (locate-user-emacs-file "config/"))
(setq custom-file (locate-user-emacs-file "custom.el"))

(require 'additional-repositories-config)
(require 'behaviour-config)
(require 'code-config)
(require 'keys-config)
(require 'ui-config)

(provide 'init)
