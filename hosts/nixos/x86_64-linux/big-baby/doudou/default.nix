{
  home = {
    stateVersion = "23.05";
  };

  modules = {
    desktop = {
      xmonad.enable = false;
      apps = {
        rofi.enable = true;
      };
      terms = {
        kitty.enable = true;
      };
      browsers = {
        #       default = "brave";
        brave.enable = true;
      };
    };
    shell = {
      fish.enable = true;
    };
    editors = {
      emacs.enable = true;
    };
  };
}
