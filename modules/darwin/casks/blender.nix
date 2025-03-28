{
  config,
  options,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.homebrew.casks.blender;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.homebrew.casks.blender = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "blender" ];
    };
  };
}
