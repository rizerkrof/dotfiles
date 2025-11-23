(use-package
 eglot
 :config
 (add-hook 'typescript-ts-mode-hook 'eglot-ensure)
 (add-hook 'tsx-ts-mode-hook 'eglot-ensure)
 (add-hook 'js-ts-mode-hook 'eglot-ensure))

(custom-set-faces
 '(eglot-highlight-symbol-face ((t (:box (:line-width (-1 . -1) :color "red") :inherit default)))))

