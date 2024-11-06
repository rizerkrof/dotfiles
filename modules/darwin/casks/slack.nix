{
  config,
  options,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.homebrew.casks.slack;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.homebrew.casks.slack = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "slack" ];
    };
  };
}
