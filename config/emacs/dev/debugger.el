(use-package
 dap-mode
 :after eglot
 :hook
 ((js-ts-mode . dap-mode)
  (tsx-ts-mode . dap-mode)
  (typescript-ts-mode . dap-mode)
  (go-mode . dap-mode))
 :config
 (dap-auto-configure-mode)
 (dap-ui-controls-mode -1)
 (require 'dap-node)
 (require 'dap-dlv-go))
