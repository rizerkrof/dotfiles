{ config, options, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.blender;
configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.blender = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = ["blender"];
    };
  };
}
