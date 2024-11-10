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
    services.docker.enable = true;
    desktop = {
      aerospace.enable = true;
      terms.kitty.enable = true;
      communications = {
        slack.enable = true;
        discord.enable = true;
      };
    };
  };
}
