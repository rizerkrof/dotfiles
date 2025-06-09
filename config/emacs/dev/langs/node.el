(reformatter-define
 prettier-format
 :program "prettier"
 :args
 (list "--stdin-filepath" (or buffer-file-name (buffer-name))))

(use-package
 typescript-ts-mode
 :mode (("\\.ts\\'" . typescript-ts-mode) ("\\.tsx\\'" . tsx-ts-mode))
 :hook
 ((typescript-ts-mode . prettier-format-on-save-mode)
  (tsx-ts-mode . prettier-format-on-save-mode)))

(use-package
 js-ts-mode
 :mode
 (("\\.js\\'" . js-ts-mode)
  ("\\.jsx\\'" . tsx-ts-mode) ; tsx-ts-mode handles JSX well
  ("\\.mjs\\'" . js-ts-mode))
 :hook
 ((js-ts-mode . prettier-format-on-save-mode)
  (tsx-ts-mode . prettier-format-on-save-mode)))

(defun my-eglot-format-buffer ()
  "Only format if not in JS/TS mode."
  (unless (derived-mode-p
           'js-mode 'typescript-mode 'tsx-ts-mode 'js-ts-mode)
    (eglot-format-buffer)))

(advice-add 'eglot-format-buffer :override #'my-eglot-format-buffer)
