(use-package
 go-mode
 :ensure t
 :mode "\\.go\\'"
 :hook
 ((go-mode . eglot-ensure) (before-save . eglot-format-buffer)))
