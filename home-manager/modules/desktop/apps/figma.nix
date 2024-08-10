{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.figma;
configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.figma = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["figma"];
    };
  };
}
