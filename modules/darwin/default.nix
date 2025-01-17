{ pkgs, ... }:
{
  system.stateVersion = 5;

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };

  # The Nix daemon is necessary in multi-user Nix installations.
  # It runs build tasks and other operations on the Nix store on behalf of unprivileged users.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  system = {
    defaults = {
      NSGlobalDomain._HIHideMenuBar = true;
      finder.CreateDesktop = false;
      dock = {
        autohide = true;
      };
    };
  };
}
