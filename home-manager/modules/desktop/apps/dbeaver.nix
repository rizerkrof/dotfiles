{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.dbeaver;
configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.dbeaver = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["dbeaver-community"];
    };
  };
}
