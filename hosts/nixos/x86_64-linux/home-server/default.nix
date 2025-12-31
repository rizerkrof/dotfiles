{ config, lib, ... }:

with builtins;
with lib;
{
  modules.services = {
    ssh.enable = true;
    fail2ban.enable = true;
    nextcloud.enable = true;
    vaultwarden.enable = true;
    jellyfin.enable = true;
  };
  modules.profiles.networks = [ "wg0" ];

  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    192.168.1.1   router.home
  '';

  time.timeZone = mkDefault "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";
}
