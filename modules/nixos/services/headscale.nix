{
  lib,
  config,
  options,
  pkgs,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.services.headscale;
  domain = "lacourt.bzh";
in
{
  options.modules.services.headscale = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services = {
      headscale = {
        enable = true;
        address = "0.0.0.0";
        port = 8002;
        serverUrl = "https://${domain}";
        settings = {
          dns.base_domain = "vpn.${domain}";
          dns.override_local_dns = false;
          logtail.enabled = false;
        };
      };

      caddy = {
        enable = true;
        virtualHosts.${domain}.extraConfig = ''
            reverse_proxy localhost:${toString config.services.headscale.port} {
              header_up Host {host}
              header_up X-Real-IP {remote}
              header_up X-Forwarded-For {remote}
              header_up X-Forwarded-Proto {scheme}
            }
        '';
      };
    };
  };
}
