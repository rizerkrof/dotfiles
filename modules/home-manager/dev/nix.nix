{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.nix;
configDir = config.dotfiles.configDir;
in {
  options.modules.dev.nix= with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };
}
