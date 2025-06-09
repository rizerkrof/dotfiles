(use-package
 company
 :defer 2
 :diminish
 :custom
 (company-begin-commands '(self-insert-command))
 (company-idle-delay .1)
 (company-minimum-prefix-length 2)
 (company-show-numbers t)
 (company-tooltip-align-annotations 't)
 (global-company-mode t))

(use-package
 company-box
 :after company
 :diminish
 :hook (company-mode . company-box-mode))

(use-package
 rainbow-delimiters
 :hook (prog-mode . rainbow-delimiters-mode))

(use-package reformatter)

(setq-default tab-width 4)

(electric-pair-mode 1)
(setq electric-pair-delete-adjacent-pairs t)
(setq electric-pair-open-newline-between-pairs t)
(setq electric-pair-pairs '((?\' . ?\') (?\` . ?\`) (?\{ . ?\})))
