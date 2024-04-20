(use-package typescript-mode
:config
(add-hook 'typescript-mode-hook 'lsp-deferred)
)
