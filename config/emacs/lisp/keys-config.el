;; -*- lexical-binding: t; -*-

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

(use-package multiple-cursors
	:bind
	("C->" . mc/mark-next-like-this)
	("C-<" . mc/mark-previous-like-this)
	("C-c C-<" . mc/mark-all-like-this)
	("C-\"" . mc/skip-to-next-like-this)
	("C-:" . mc/skip-to-previous-like-this)
	:defer t
	:ensure t
	)

(setq default-input-method "english-colemak")
(when (eq system-type 'darwin)
	(setq mac-right-option-modifier 'none)
	)

(keymap-global-unset "C-x C-b") ;; unset list-buffers
(keymap-global-set "C-x C-b" 'ibuffer) ;; set ibuffer

(keymap-global-set "C-;" 'comment-line) ;; faster keybind to comments
(keymap-global-set "C-_" 'undo-only) ;; Instead of undo I like undo-only

(provide 'keys-config)
