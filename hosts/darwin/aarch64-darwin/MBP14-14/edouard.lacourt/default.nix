{
  home = {
    stateVersion = "25.05";
  };

  modules = {
    shell.fish.enable = true;
    dev.nix.enable = true;
    dev.python.enable = true;
    dev.node.enable = true;
    services.colima.enable = true;
    editors.emacs = {
      enable = true;
    };
    desktop = {
      browsers = {
        chrome.enable = true;
        firefox.enable = true;
      };
      editors.vscode.enable = true;
      aerospace.enable = true;
      terms.kitty.enable = true;
    };
  };
}
