{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.nextcloud;
in {
  options.modules.services.nextcloud = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Only used for first login. Do not forget to change it under settings/user/security
    # default user is root
    environment.etc."nextcloud-admin-pass".text = "PWD";

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "lacourt.bzh";  # base domain only, no /cloud
      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };

      # Configure for reverse proxy
      settings = {
        trusted_proxies = [ "127.0.0.1" ];
        overwritehost = "lacourt.bzh";
        overwriteprotocol = "https";
      };
   };

   # nexcloud comes with nginx to expose it. Default settings confict with caddy.
   # the work around is to override nginx settings to expose nextcloud on local host 
   # and redirect localhost to internet with caddy
   # nextcloud -> niginx > localhost -> caddy -> internet
   services.nginx = {
      virtualHosts.${config.services.nextcloud.hostName} = {
        listen = [
          { addr = "127.0.0.1"; port = 8001; }
        ];
      };
    };
    
    # Caddy proxies to nginx
    services.caddy = {
      virtualHosts."lacourt.bzh" = {
        extraConfig = ''
          handle /cloud* {
            uri strip_prefix /cloud
            reverse_proxy 127.0.0.1:8001
          }
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
