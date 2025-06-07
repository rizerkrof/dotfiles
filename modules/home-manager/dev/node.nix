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
  cfg = config.modules.dev.node;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.dev.node = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      pnpm
      typescript
      typescript-language-server
      nodePackages.prettier
    ];
  };
}
