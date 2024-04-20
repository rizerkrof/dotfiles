(use-package nix-mode
  :mode "\\.nix\\'"
  :config
  (add-hook 'after-save-hook 'nix-mode-format)
)
