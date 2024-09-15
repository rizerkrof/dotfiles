{ inputs, lib, ... }:

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

  mkNixosHost = hostDir: system: 
  let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  nixosSystem {
    inherit system lib pkgs;
    specialArgs = { inherit pkgs inputs home-manager system; };
    modules = [
      ../default.nix
      {
        nixpkgs.pkgs = pkgs;
        networking.hostName = mkDefault (baseNameOf hostDir);
      }
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
      "${hostDir}/default.nix"
      "${hostDir}/hardware-configuration.nix"
      ../modules/default.nix
      (mapHostUsersHome hostDir ../modules/home-manager "home" ../modules/options.nix)
    ] ++ (mapModulesRec' ../modules/nixos import);
  };
}
