{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.fish;
configDir = config.dotfiles.configDir;
in {
  options.modules.shell.fish = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    programs.fish = {
      enable = true;
    };

    home.packages = with pkgs; [
      fish
      bat
      eza
      zoxide
      fd
      fzf
      jq
      ripgrep
      tldr
    ];

    home.configFile.fish = {
        source = "${configDir}/fish";
        recursive = true;
    };
  };
}
