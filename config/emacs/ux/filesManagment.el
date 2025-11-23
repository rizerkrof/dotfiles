(use-package dired-single)

(use-package
 dired
 :ensure nil
 :custom ((dired-listing-switches "-agho --group-directories-first"))
 :config
 (evil-collection-define-key
  'normal
  'dired-mode-map
  "h"
  'dired-single-up-directory
  "l"
  'dired-single-buffer))

(use-package
 all-the-icons-dired
 :hook (dired-mode . all-the-icons-dired-mode))

(use-package helm :ensure t :config (helm-mode 1))

(use-package
 evil-collection
 :after (evil helm)
 :config (evil-collection-init 'helm))

(add-hook 'helm-minibuffer-set-up-hook #'evil-insert-state)
