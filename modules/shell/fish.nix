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
    users.defaultUserShell = pkgs.fish;
    
    programs.fish = {
      enable = true;
    };

    user.packages = with pkgs; [
      fish
      bat
      eza
      fd
      fzf
      jq
      ripgrep
      tldr
    ];
  };
}
