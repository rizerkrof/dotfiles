(reformatter-define
 prettier-format
 :program "prettier"
 :args
 (list "--stdin-filepath" (or buffer-file-name (buffer-name))))

(use-package
 typescript-mode
 :mode "\\.ts\\'"
 :hook
 ((typescript-mode . eglot-ensure)
  (typescript-mode . prettier-format-on-save-mode)))

(use-package
 web-mode
 :mode ("\\.tsx\\'" . web-mode)
 :config
 (setq web-mode-content-types-alist '(("tsx" . "\\.tsx\\'")))
 (add-hook 'web-mode-hook #'eglot-ensure)
 (add-hook 'web-mode-hook #'prettier-format-on-save-mode))
