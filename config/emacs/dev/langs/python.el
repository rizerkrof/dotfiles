(use-package reformatter
 :ensure t)

(reformatter-define black-format
 :program "black" ;; installed via venv (.venv/bin/black)
 :args '("-"))

(add-hook 'python-mode-hook #'black-format-on-save-mode)

(add-to-list 'eglot-server-programs
             '(python-mode . ("pyright-langserver" "--stdio")))
