{ config, pkgs, ... }:

{
  # The set of packages that appear in /run/current-system/sw.
  # These packages are automatically available to all users, and are automatically updated every time you rebuild the system configuration.
  # (The latter is the main difference with installing them in the default profile, /nix/var/nix/profiles/default.
  environment.systemPackages = [
    pkgs.home-manager
  ];

  stylix.enable = true;
  stylix.image = ../wallpaper.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
}
