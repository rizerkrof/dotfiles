{
  config,
  options,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.homebrew.casks.dbeaver;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.homebrew.casks.dbeaver = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "dbeaver-community" ];
    };
  };
}
