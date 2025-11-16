{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.editors.vscode;
in
{
  options.modules.desktop.editors.vscode = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];

    programs.vscode = {
      enable = true;

      profiles.default = {
        userSettings = {
          # global settings
          "editor.formatOnSave" = true;
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 500;
          "workbench.sideBar.location" = "right";

          # jnoortheen.nix-ide settings
          "nix.serverPath" = "nixd";
          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = [ "nixfmt" ]; # or alejandra or nixpkgs-fmt
              };
            };
          };
        };

        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          vscodevim.vim
        ];
      };
    };

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      vscode
    ];
  };
}
