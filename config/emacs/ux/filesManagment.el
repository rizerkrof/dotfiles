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
