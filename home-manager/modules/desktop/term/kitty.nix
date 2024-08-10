{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.kitty;
configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.kitty = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["kitty"];
    };
  };
}
