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
      (modulesDir + "/homebrew/casks/iterm2.nix")
      (modulesDir + "/homebrew/casks/slack.nix")
      (modulesDir + "/homebrew/casks/figma.nix")
      (modulesDir + "/homebrew/casks/blender.nix")
      (modulesDir + "/homebrew/casks/dbeaver.nix")
    ];
    home-manager.users = mapAttrs
      (n: v: {
        imports = [
          (hostDir + "/${n}/default.nix")
          (modulesDir + "/options.nix")
          (modulesDir + "/home-manager/desktop/term/kitty.nix")
          (modulesDir + "/home-manager/shells/fish.nix")
          (modulesDir + "/home-manager/shells/hello.nix")
        ];
      })
      (filterAttrs (n: v: v == "directory") (readDir hostDir));
    users.users = mapAttrs
      (n: v: { home = "/Users/${n}"; })
      (readDir hostDir);
  };
}
