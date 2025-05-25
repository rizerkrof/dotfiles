{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (
    let
      configOptions = [
        { configFilePath = "ui/global.el"; }
        { configFilePath = "ui/theme.el"; }
        {
          configFilePath = "ui/modeline.el";
          epkgs =
            epkgs: with epkgs; [
              doom-modeline
              nyan-mode
            ];
        }
        {
          enable = true;
          configFilePath = "ux/keybindings.el";
          epkgs =
            epkgs: with epkgs; [
              general # manages keybindings
              evil
              evil-collection
              goto-chg # dependency of evil
            ];
        }
        {
          configFilePath = "ux/minibuffer.el";
          epkgs =
            epkgs: with epkgs; [
              ivy
              counsel
              ivy-rich
            ];
        }
        { configFilePath = "ux/macos.el"; }
        {
          configFilePath = "ux/projectsManagment.el";
          epkgs =
            epkgs: with epkgs; [
              projectile
              counsel-projectile
            ];
        }
        {
          configFilePath = "ux/filesManagment.el";
          epkgs =
            epkgs:
            with epkgs;
            let
              # dired-single is not available using the emacsPackagesFor function so it's packaged manually here
              dired-single = epkgs.trivialBuild {
                pname = "dired-single";
                version = "0.3.1";

                src = pkgs.fetchurl {
                  url = "https://github.com/emacsattic/dired-single/archive/refs/tags/v0.3.1.tar.gz";
                  sha256 = "sha256-YFGFib0WpARIHKMxK5PenUDssykOa60uVHWTeQt2XJ4=";
                };

                meta = with lib; {
                  homepage = "https://github.com/emacsattic/dired-single";
                  description = "Reuse the same Dired buffer to navigate directories";
                  license = licenses.gpl3Plus;
                };
              };
            in
            [
              dired-single
              dired-rainbow
              all-the-icons-dired
            ];
        }
        {
          configFilePath = "ux/edit.el";
          epkgs =
            epkgs: with epkgs; [
              flycheck
              company
              company-box
              rainbow-delimiters
              reformatter
            ];
        }
        {
          configFilePath = "ux/dashboard.el";
          epkgs = epkgs: with epkgs; [ dashboard ];
        }
        {
          configFilePath = "ux/rssFeeds.el";
          epkgs = epkgs: with epkgs; [ elfeed ];
        }
        {
          configFilePath = "dev/git.el";
          enable = true;
          epkgs = epkgs: with epkgs; [ magit ];
        }
        {
          configFilePath = "dev/langs/elisp.el";
          enable = config.modules.dev.python.enable; # Python needed for elisp-autofmt
          epkgs = epkgs: with epkgs; [ elisp-autofmt ];
        }
        {
          configFilePath = "dev/langs/typescript.el";
          enable = config.modules.dev.typescript.enable;
          epkgs =
            epkgs: with epkgs; [
              typescript-mode
              web-mode
            ];
        }
        {
          configFilePath = "dev/langs/nix.el";
          enable = config.modules.dev.nix.enable;
          epkgs = epkgs: with epkgs; [ nix-mode ];
        }
        {
          configFilePath = "dev/langs/org.el";
          enable = true;
          epkgs =
            epkgs: with epkgs; [
              org
              org-bullets
              toc-org
            ];
        }
      ];
    in
    {
      programs.emacs = {
        enable = true;
        extraPackages =
          epkgs:
          lib.flatten (
            lib.concatMap (
              opt: lib.optionals ((!(opt ? enable) || opt.enable) && opt ? epkgs) (opt.epkgs epkgs)
            ) configOptions
          );
      };

      home.packages = with pkgs; [
        coreutils # For GNU ls. Needed by dired config on macOS.
      ];

      home.configFile = mkMerge [
        (listToAttrs (
          concatMap (
            opt:
            optional (!(opt ? enable) || opt.enable) {
              name = "emacs/${opt.configFilePath}";
              value.source = "${configDir}/emacs/${opt.configFilePath}";
            }
          ) configOptions
        ))
        {
          "emacs/sandbox.el".text = ''
            ;; Use this config file to experiment config quickly
          '';
          "emacs/init.el".text = ''
            ;; Disable built-in package.el
            (setq package-enable-at-startup nil)
            (setq package--init-file-ensured t)
            (setq package-user-dir (concat user-emacs-directory "elpa-disabled"))

            (setq config-files
            '(${
              lib.concatStringsSep "\n          " (
                map (
                  opt: lib.optionalString (!(opt ? enable) || opt.enable) "\"${opt.configFilePath}\""
                ) configOptions
              )
            }
            "sandbox.el"))

            (dolist (file config-files)
            (load-file (concat user-emacs-directory file)))
          '';
        }
      ];
    }
  );
}
