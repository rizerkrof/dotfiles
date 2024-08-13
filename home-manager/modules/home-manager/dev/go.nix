{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.go;
configDir = config.dotfiles.configDir;
in {
  options.modules.dev.go = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    programs.fish = {
      enable = true;
    };

    home.packages = with pkgs; [
      go
    ];
  };
}
