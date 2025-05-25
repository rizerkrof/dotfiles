(use-package
 projectile
 :config (projectile-mode)
 :init
 (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile :config (counsel-projectile-mode))
