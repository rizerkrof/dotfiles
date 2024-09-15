{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.terms;
in {
  options.modules.desktop.terms= {
    default = mkOpt types.str "xterm";
  };

  config = {
    services.xserver.desktopManager.xterm.enable = mkDefault (cfg.default == "xterm");

    environment.variables = {
      TERMINAL = cfg.default;
    };
  };
}
