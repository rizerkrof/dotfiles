(setq config-files
      '("modules/packages/packages-config.el"
	"modules/gui/gui-config.el"
	"modules/ux/key-bindings/key-bindings-config.el"
	"modules/ux/utils/utils-config.el"
	"modules/ux/tools/tools-config.el"
	"modules/dev/shells/shells-config.el"
	"modules/dev/git/git-config.el"
	"modules/dev/lsp/lsp-config.el"
	"modules/dev/lang/org-mode/org-mode-config.el"
	"modules/dev/lang/nix/nix-config.el"
	"modules/dev/lang/go/go-config.el"
))

(dolist (file config-files)
	(load-file (concat user-emacs-directory file)))
