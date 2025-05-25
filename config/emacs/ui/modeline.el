(use-package
 doom-modeline
 :init
 (setq
  doom-modeline-height 25
  doom-modeline-bar-width 5)
 :config (doom-modeline-mode 1))

(use-package
 nyan-mode
 :config (nyan-mode) (nyan-start-animation) (nyan-toggle-wavy-trail))
