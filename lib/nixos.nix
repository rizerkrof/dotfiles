{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let 
  sys = "x86_64-linux";
  inherit (builtins) readDir;
in {
  mkHost = path: attrs @ { system ? sys, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ../.   # /default.nix
        (import path)
      ];
    };

  mapHosts = dir: attrs @ { system ? sys, ... }:
    mapModules dir (hostPath: mkHost hostPath attrs);

  mapHostUsers = hostDir: modulesDir: {
    imports = [
      (hostDir + "/default.nix")
    ] ++ mapModulesRec' (modulesDir + "/homebrew") import;
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
