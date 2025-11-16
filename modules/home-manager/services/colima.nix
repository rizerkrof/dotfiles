{
  config,
  options,
  pkgs,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.services.colima;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.services.colima = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      colima
      docker
      lazydocker
    ];
  };
}
