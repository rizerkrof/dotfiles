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
  cfg = config.modules.desktop.terms.kitty;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.terms.kitty = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.kitty.enable = true;

    home.packages = with pkgs; [
      kitty
    ];

    home.configFile = {
      "kitty/kitty.conf".text = ''
        globinclude kitty.d/**/*.conf
      '';
    };
  };
}
