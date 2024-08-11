{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.homebrew.casks.iterm2;
configDir = config.dotfiles.configDir;
in {
  options.modules.homebrew.casks.iterm2 = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["iterm2"];
    };
  };
}
