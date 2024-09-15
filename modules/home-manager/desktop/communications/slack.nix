{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.communications.slack;
configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.communications.slack = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];

    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
    };
  };
}
