
{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.vaultwarden;
in {
  options.modules.services.vaultwarden = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_ADDRESS = "0.0.0.0";  # Bind to all network interfaces (LAN accessible)
        ROCKET_PORT = 8000;
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."vault.lacourt.bzh".extraConfig = ''
        tls internal
        reverse_proxy 127.0.0.1:8000
      '';
    };
  };
}
