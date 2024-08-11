{ config, pkgs, ... }:

{
  # The set of packages that appear in /run/current-system/sw. 
  # These packages are automatically available to all users, and are automatically updated every time you rebuild the system configuration. 
  # (The latter is the main difference with installing them in the default profile, /nix/var/nix/profiles/default.
  environment.systemPackages = [
    pkgs.home-manager
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };

  # The Nix daemon is necessary in multi-user Nix installations.
  # It runs build tasks and other operations on the Nix store on behalf of unprivileged users.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = [ "nix-command" "flakes"];
    };
  };
}