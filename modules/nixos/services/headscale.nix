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
  serverIp = "100.64.0.3";
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
          dns.extra_records = [
            {
              name = "home.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "cloud.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "vault.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "watch.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "streaming.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "radarr.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "sonarr.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "prowlarr.${domain}";
              type = "A";
              value = serverIp;
            }
            {
              name = "torrent.${domain}";
              type = "A";
              value = serverIp;
            }
          ];
          logtail.enabled = false;
        };
        # setup 
        # server: sudo headscale namespaces create home
        # client: sudo tailscale up --login-server=https://${domain}
        # server: sudo headscale nodes register --key <key> --user home

        # tricks
        # sudo headscale node list
        # sudo headscale nodes rename -i <id> <new-name>
        
        # exit node setup
        # exit client: sudo tailscale set --advertise-exit-node
        # server     : sudo headscale node list-routes
        # server     : sudo headscale nodes approve-routes -i <id> -r 0.0.0.0/0
        # user client: sudo tailscale set --exit-node <node-name>

        # to quit exit node:
        # sudo tailscale down 
        # sudo tailscale up
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
