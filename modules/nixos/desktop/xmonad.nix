{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.xmonad;
in
#configDir = config.dotfiles.configDir;
{
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
