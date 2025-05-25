(use-package
 elisp-autofmt
 :hook (emacs-lisp-mode . elisp-autofmt-mode)
 :config (setq elisp-autofmt-on-save-p 'always))
