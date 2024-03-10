{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.xmonad;
configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.xmonad = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.windowManager.xmonad = {
       enable = true;
       enableContribAndExtras = true;
    };

    home.configFile = {
       "xmonad" = {
          source = "${configDir}/xmonad";
          recursive = true;
       };
    };
  };
}
