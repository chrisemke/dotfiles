(add-to-list 'default-frame-alist '(background-color . "#1e1e2e"))

(menu-bar-mode 0)
(tool-bar-mode 0)

;; Transparent title bar
(set-frame-parameter nil 'ns-transparent-titlebar t)
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

(provide 'early-init)
