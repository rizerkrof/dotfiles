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
  cfg = config.modules.services.docker;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.services.docker = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      docker
    ];
  };
}
