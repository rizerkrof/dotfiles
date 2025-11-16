{
  nix.enable = false; # because nix was installed via determinate systems
  system.primaryUser = "edouard.lacourt";

  modules = {
    homebrew.casks = {
      dbeaver.enable = true;
    };
  };
}
