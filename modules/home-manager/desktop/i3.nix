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
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.i3 = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.configFile = {
      "i3" = {
        source = "${configDir}/i3";
        recursive = true;
      };
    };
  };
}
