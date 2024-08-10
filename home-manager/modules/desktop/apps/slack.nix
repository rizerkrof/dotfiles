{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.slack;
configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.slack = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["slack"];
    };
  };
}
