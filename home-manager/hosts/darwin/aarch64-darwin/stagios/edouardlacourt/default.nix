{
  home = {
    stateVersion = "23.05";
  };

  modules = {   
    shell.fish.enable = true;
    dev.go.enable = true;
    dev.node.enable = true;
    desktop = {
      terms.kitty.enable = true;
      communications = {
        slack.enable = true;
        discord.enable = true;
      };
    };
  };
}