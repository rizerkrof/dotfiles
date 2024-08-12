{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.tests.hello;
configDir = config.dotfiles.configDir;
in {
  options.modules.tests.hello = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hello
    ];
  };
}
