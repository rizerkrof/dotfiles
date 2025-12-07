(use-package
 doom-modeline
 :init
 (setq
  doom-modeline-height 25
  doom-modeline-bar-width 5)

 :config (doom-modeline-mode 1))

(use-package
 nyan-mode
 :config
 (defun activate-nyan-mode ()
   (nyan-mode)
   (nyan-start-animation)
   (nyan-toggle-wavy-trail))

 (defun toggle-nyan-for-windows ()
   (if (> (length (window-list)) 1)
       (nyan-mode -1)
     (activate-nyan-mode)))

 (activate-nyan-mode)

 (add-hook
  'window-configuration-change-hook #'toggle-nyan-for-windows)
 (add-hook
  'window-size-change-functions
  (lambda (frame) (toggle-nyan-for-windows))))

(column-number-mode 1)

(add-hook
 'after-init-hook
 (lambda ()
   (let ((line-color (face-foreground 'mode-line-inactive)))
     (set-face-attribute 'mode-line nil
                         :background "unspecified"
                         :underline `(:color ,line-color :position t)
                         :box nil)
     (set-face-attribute 'mode-line-inactive nil
                         :background "unspecified"
                         :underline `(:color ,line-color :position t)
                         :box nil))))
