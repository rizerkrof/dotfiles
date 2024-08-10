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
      (modulesDir + "/desktop/term/kitty.nix")
      (modulesDir + "/desktop/term/iterm2.nix")
      (modulesDir + "/desktop/apps/slack.nix")
    ];
    home-manager.users = mapAttrs
      (n: v: {
        imports = [
          (modulesDir + "/options.nix")
          (hostDir + "/${n}/default.nix")
          (modulesDir + "/shells/fish.nix")
          (modulesDir + "/shells/hello.nix")
        ];
      })
      (filterAttrs (n: v: v == "directory") (readDir hostDir));
    users.users = mapAttrs
      (n: v: { home = "/Users/${n}"; })
      (readDir hostDir);
  };
}
