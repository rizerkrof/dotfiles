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
  cfg = config.modules.desktop.aerospace;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.aerospace = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.configFile = {
      "aerospace" = {
        source = "${configDir}/aerospace";
        recursive = true;
      };
    };
  };
}
