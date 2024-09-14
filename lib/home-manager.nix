{ inputs, lib, ... }:

with lib;
with lib.my;
let 
  inherit (builtins) readDir;
in {
  mapHostUsersHome = hostDir: modulesDir: options: {
    home-manager.users = mapAttrs
      (n: v: {
        imports = [
          (hostDir + "/${n}/default.nix")
          options
        ] ++ mapModulesRec' modulesDir import;
      })
      (filterAttrs (n: v: v == "directory") (readDir hostDir));
    users.users = mapAttrs
      (n: v: { home = "/Users/${n}"; })
      (readDir hostDir);
  };
}
