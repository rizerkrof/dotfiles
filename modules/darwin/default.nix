{ pkgs, ... }:
{
  system.stateVersion = 5;

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };

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
