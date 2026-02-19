(add-to-list 'default-frame-alist '(background-color . "#1e1e2e"))

(setq gc-cons-threshold 100000000
			gc-cons-percentage 0.6
			read-process-output-max 1048576)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Transparent title bar
(set-frame-parameter nil 'ns-transparent-titlebar t)
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

(provide 'early-init)
