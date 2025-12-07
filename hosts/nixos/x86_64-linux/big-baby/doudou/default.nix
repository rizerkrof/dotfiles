{
  home = {
    stateVersion = "23.05";
  };

  modules = {
    desktop = {
      i3.enable = true;
      apps = {
        rofi.enable = true;
        steam.enable = true;
      };
      terms = {
        kitty.enable = true;
      };
      browsers = {
        brave.enable = true;
      };
    };
    shell = {
      fish.enable = true;
    };
    dev = {
      python.enable = true;
      nix.enable = true;
    };
    editors = {
      emacs.enable = true;
    };
  };
}
