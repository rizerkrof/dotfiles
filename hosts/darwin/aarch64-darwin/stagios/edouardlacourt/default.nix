{
  home = {
    stateVersion = "23.05";
  };

  modules = {
    shell.fish.enable = true;
    shell.nushell.enable = true;
    dev.go.enable = true;
    dev.node.enable = true;
    dev.nix.enable = true;
    dev.python.enable = true;
    dev.typescript.enable = true;
    services.docker.enable = true;
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
      communications = {
        slack.enable = true;
        discord.enable = true;
      };
    };
  };
}
