{
  config,
  options,
  pkgs,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.dev.typescript;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.dev.typescript = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      typescript
      typescript-language-server
      nodePackages.prettier
    ];
  };
}
