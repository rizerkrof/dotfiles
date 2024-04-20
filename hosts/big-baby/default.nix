{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      xmonad.enable = true;
      apps = {
        rofi.enable = true;
      };
      term = {
        default = "kitty";
        kitty.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
      };
    };
    editors = {
      emacs.enable = true;
    };
    theme.active = "dark";
  };

  networking.networkmanager.enable = true;
}
