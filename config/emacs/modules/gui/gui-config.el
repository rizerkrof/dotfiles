(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

(defun doudou/inhibit-startup-screen-always ()
  "Startup screen inhibitor for `command-line-functions`.
Inhibits startup screen on the first unrecognised option."
  (ignore (setq inhibit-startup-screen t)))

(add-hook 'command-line-functions #'doudou/inhibit-startup-screen-always)

(set-face-attribute 'default nil
   :font "JetBrains Mono"
   :height 110
   :weight 'medium)
 (set-face-attribute 'variable-pitch nil
   :font "Ubuntu"
   :height 120
   :weight 'medium)
 (set-face-attribute 'fixed-pitch nil
   :font "JetBrains Mono"
   :height 110
   :weight 'medium)

 ;; Makes commented text and keywords italics.
 ;; This is working in emacsclient but not emacs.
 ;; Your font must have an italic face available.
 (set-face-attribute 'font-lock-comment-face nil
   :slant 'italic)
 (set-face-attribute 'font-lock-keyword-face nil
   :slant 'italic)

 ;; This sets the default font on all graphical frames created after restarting Emacs.
 ;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
 ;; are not right unless I also add this method of setting the default font.
 (add-to-list 'default-frame-alist '(font . "JetBrains Mono-11"))

 ;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.1)

(use-package all-the-icons
:ensure t
:if (display-graphic-p))

(use-package all-the-icons-dired
:hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package all-the-icons-ivy-rich
:ensure t
:init (all-the-icons-ivy-rich-mode 1))

(use-package nerd-icons)

(use-package doom-themes
:ensure t
:config
;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-horizon t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config))

(use-package rainbow-mode
  :hook 
  ((org-mode prog-mode) . rainbow-mode))

(use-package rainbow-delimiters
 :hook ((emacs-lisp-mode . rainbow-delimiters-mode)
         (go-mode . rainbow-delimiters-mode)
         (typescript-mode . rainbow-delimiters-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-base-error-face ((t (:inherit rainbow-delimiters-base-face :background "white smoke" :foreground "#e95678"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow1"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "magenta"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "deep pink"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "firebrick"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "red")))))

(add-to-list 'default-frame-alist '(alpha-background . 90)) ; For all new frames henceforth

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25      ;; sets modeline height
        doom-modeline-bar-width 5    ;; sets right bar width
        doom-modeline-persp-name t   ;; adds perspective name to modeline
        doom-modeline-persp-icon t)) ;; adds folder icon next to persp name

(use-package nyan-mode
:config
(nyan-mode)
(nyan-start-animation)
(nyan-toggle-wavy-trail)
)
