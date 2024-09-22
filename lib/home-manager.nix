{ inputs, lib, ... }:

with lib;
with lib.my;
let 
inherit (builtins) readDir;
in {
  mapHostUsersHome = hostDir: modulesDir: homeDir: options: {
    home-manager.extraSpecialArgs = {inherit inputs; };
    home-manager.users = mapAttrs
    (user: v: {
      imports = [
        (hostDir + "/${user}/default.nix")
        options
      ] ++ mapModulesRec' modulesDir import;
      home.username = user;
      home.homeDirectory = "/${homeDir}/${user}";
      programs.home-manager.enable = true;
      xdg.enable = true;
    })
    (filterAttrs (n: v: v == "directory") (readDir hostDir));
  };
}
