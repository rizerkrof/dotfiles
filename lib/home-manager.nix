{ inputs, lib, ... }:

with lib;
with lib.my;
let 
  inherit (builtins) readDir;
in {
  mapHostUsers = hostDir: modulesDir: {
    home-manager.users = mapAttrs
      (n: v: {
        imports = [
          (hostDir + "/${n}/default.nix")
          (modulesDir + "/options.nix")
        ] ++ mapModulesRec' (modulesDir + "/home-manager") import;
      })
      (filterAttrs (n: v: v == "directory") (readDir hostDir));
    users.users = mapAttrs
      (n: v: { home = "/Users/${n}"; })
      (readDir hostDir);
  };
}
