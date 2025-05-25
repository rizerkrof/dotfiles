(use-package
 doom-modeline
 :init (doom-modeline-mode 1)
 :config
 (setq
  doom-modeline-height 25
  doom-modeline-bar-width 5))

(use-package
 nyan-mode
 :config (nyan-mode) (nyan-start-animation) (nyan-toggle-wavy-trail))
