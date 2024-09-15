{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.homebrew.casks.figma;
configDir = config.dotfiles.configDir;
in {
  options.modules.homebrew.casks.figma = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["figma"];
    };
  };
}
