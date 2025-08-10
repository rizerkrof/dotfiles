
{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.vaultwarden;
in {
  options.modules.services.vaultwarden = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_ADDRESS = "0.0.0.0";  # Bind to all network interfaces (LAN accessible)
        ROCKET_PORT = 8000;
      };
    };

    networking.firewall.allowedTCPPorts = [ 8000 ];
  };
}
