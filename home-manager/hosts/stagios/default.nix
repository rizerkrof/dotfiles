{ config, pkgs, lib,... }:

{
  home = {
    stateVersion = "23.05";
  };

  modules = {   
    shell.fish.enable = true;
  };
}