(defun my/magit-faces-patch (&optional frame)
  "Patch Magit faces for GUI and terminal frames."
  (with-selected-frame (or frame (selected-frame))
    (let ((green (face-foreground 'ansi-color-green nil t))
          (red (face-foreground 'ansi-color-red nil t))
          (yellow (face-foreground 'ansi-color-yellow nil t))
          (black (face-background 'default nil t))
          (magenta (face-foreground 'ansi-color-magenta nil t)))
      (custom-theme-set-faces 'user
                              `(magit-section-heading
                                ((t
                                  (:inherit
                                   default
                                   :foreground ,yellow))))
                              `(magit-section-highlight
                                ((t
                                  (:inherit
                                   default
                                   :weight bold
                                   :background ,black))))
                              `(magit-diff-file-heading
                                ((t
                                  (:inherit
                                   default
                                   :foreground ,magenta))))
                              `(magit-diff-file-heading-highlight
                                ((t
                                  (:inherit
                                   default
                                   :weight bold
                                   :foreground ,magenta))))
                              `(magit-diff-context-highlight
                                ((t
                                  (:inherit
                                   default
                                   :weight bold
                                   :background ,black))))
                              `(magit-diff-added
                                ((t
                                  (:inherit
                                   default
                                   :foreground ,green))))
                              `(magit-diff-added-highlight
                                ((t
                                  (:inherit
                                   default
                                   :weight bold
                                   :foreground ,green))))
                              `(magit-diff-removed
                                ((t
                                  (:inherit
                                   default
                                   :foreground ,red))))
                              `(magit-diff-removed-highlight
                                ((t
                                  (:inherit
                                   default
                                   :weight bold
                                   :foreground ,red))))
                              `(diff-refine-added
                                ((t
                                  (:inherit
                                   default
                                   :background ,green
                                   :foreground ,black))))
                              `(diff-refine-removed
                                ((t
                                  (:inherit
                                   default
                                   :background ,red
                                   :foreground ,black))))))))

(my/magit-faces-patch)
(add-hook 'after-load-theme-hook #'my/magit-faces-patch)
(add-hook 'after-make-frame-functions #'my/magit-faces-patch)

(use-package
 magit
 :custom
 (magit-display-buffer-function
  #'magit-display-buffer-same-window-except-diff-v1)
 (magit-diff-refine-hunk 'all)
 :config
 (add-hook 'after-load-theme-hook #'my/magit-faces-patch)
 (my/magit-faces-patch))
