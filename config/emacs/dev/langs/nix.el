;; Could not use reformatted package because nixfmt need the buffer to be saved before
;; nixfmt does not support sdtin input
(defun my/nixfmt-format-buffer ()
  "Format the current buffer using nixfmt. Requires the buffer to be saved."
  (interactive)
  (if buffer-file-name
      (progn
        (save-buffer)
        (let ((exit-code
               (call-process "nixfmt" nil nil nil buffer-file-name)))
          (if (zerop exit-code)
              (progn
                (revert-buffer :ignore-auto :noconfirm)
                (message "Formatted with nixfmt"))
            (message "nixfmt failed with exit code %d" exit-code))))
    (message "Buffer is not visiting a file")))

(use-package nix-mode :mode "\\.nix\\'")

(add-hook
 'nix-mode-hook
 (lambda ()
   (add-hook 'after-save-hook #'my/nixfmt-format-buffer nil t)))
