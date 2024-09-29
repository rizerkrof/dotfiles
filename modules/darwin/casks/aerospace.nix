{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.homebrew.casks.aerospace;
configDir = config.dotfiles.configDir;
in {
  options.modules.homebrew.casks.aerospace = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["nikitabobko/tap/aerospace"];
    };
  };
}