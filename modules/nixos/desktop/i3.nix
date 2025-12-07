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
  cfg = config.modules.desktop.i3;
in
{
  options.modules.desktop.i3 = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services = {
      picom = {
        enable = true;
        backend = "glx"; # or "xrender" if GLX is problematic
        vSync = true;
        inactiveOpacity = 0.9;
        activeOpacity = 0.94;
        settings = {
          corner-radius = 12;
          frame-opacity = 0.7;
          blur = {
            method = "dual_kawase";
            size = 10;
            strength = 5;
          };
        };
      };
      xserver = {
        enable = true;
        windowManager.i3.enable = true;
      };
    };
  };
}
