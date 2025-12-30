(cua-mode t)

(setq-default indent-tabs-mode t
							standard-indent 2
							tab-width 2
							)

(use-package dtrt-indent
	:custom
	(dtrt-indent-verbosity 0)
	(dtrt-indent-run-after-smie t)
	:ensure t
	:hook (prog-mode . dtrt-indent-mode)
	)

;; Comment/Uncomment lines better than comment-dwim
(use-package evil-nerd-commenter
	:bind ("C-/" . evilnc-comment-or-uncomment-lines)
	:config (evilnc-default-hotkeys)
	:ensure t
	)

(global-set-key (kbd "C-a") 'mark-whole-buffer)

(provide 'keys-config)
