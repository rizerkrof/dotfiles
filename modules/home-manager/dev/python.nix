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
  cfg = config.modules.dev.python;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.dev.python = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python3
    ];
  };
}
