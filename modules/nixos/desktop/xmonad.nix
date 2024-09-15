{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.xmonad;
#configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.xmonad = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services = {
      #picom.enable = true;
      xserver = {
        enable = true;
        windowManager.i3.enable = true;
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
    };
  };
}
