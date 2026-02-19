(cua-mode t)

;; Ajust tab defaults and tab character deletion
(setq-default indent-tabs-mode t
							standard-indent 2
							tab-width 2
							backward-delete-char-untabify-method nil
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

(use-package multiple-cursors
	:bind (("C->" . mc/mark-next-like-this)
				 ("C-<" . mc/skip-to-next-like-this)
				 ("C-M->" . mc/mark-all-like-this)
				 ("C-{" . mc/mark-previous-like-this)
				 ("C-}" . mc/skip-to-previous-like-this))
	:defer t
	:ensure t
	)

(global-set-key (kbd "C-a") 'mark-whole-buffer)

(provide 'keys-config)
