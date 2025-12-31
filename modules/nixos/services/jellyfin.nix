{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.jellyfin;
in {
  options.modules.services.jellyfin = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
      };
      jellyseerr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };
      radarr = {
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
      qbittorrent = {
        enable = true;
        openFirewall = true;
        serverConfig = {
          LegalNotice = {
            Accepted = true;
          };
          Preferences = {
            WebUI = {
              Username = "admin";
              # Password generated using https://codeberg.org/feathecutie/qbittorrent_password
              # This example hash corresponds to password "adminadmin"
              # Do not forget to change this password under ip:8080 > Tools > Options > WebUI
              Password_PBKDF2 = "@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)";
            };
            General = {
              Locale = "en";
            };
          };
        };
      };
    };

    users.groups.media = {
      members = [ "qbittorrent" "radarr" "jellyseerr" ];
    };

    systemd.tmpfiles.rules = [
      # Ensure the directory exists and is owned by the media group
      "d /var/lib/qBittorrent/qBittorrent/downloads 0775 qbittorrent media -"
      # Ensure movies library dir exists
      "d /srv/media/movies 0775 radarr media -"
      # Ensure series library dir exists
      "d /srv/media/series 0775 sonarr media -"
    ];
  };
}
