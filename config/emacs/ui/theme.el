;; Theme is mostly handled by nix stylix

(defun fix-fringe-background (&optional frame)
  "Make sure fringe background matches default buffer background."
  (with-selected-frame (or frame (selected-frame))
    (set-face-attribute
     'fringe nil
     :background (face-attribute 'default :background))))

(add-hook 'after-load-theme-hook #'fix-fringe-background)
(add-hook 'emacs-startup-hook #'fix-fringe-background)
(add-hook 'after-make-frame-functions #'fix-fringe-background)


(defun fix-line-numbers-background (&optional frame)
  "Make sure line number background matches default buffer background."
  (with-selected-frame (or frame (selected-frame))
    (set-face-attribute
     'line-number nil
     :background (face-attribute 'default :background))
    (set-face-attribute
     'line-number-current-line nil
     :background (face-attribute 'default :background))))

(add-hook 'after-load-theme-hook #'fix-line-numbers-background)
(add-hook 'emacs-startup-hook #'fix-line-numbers-background)
(add-hook 'after-make-frame-functions #'fix-line-numbers-background)
