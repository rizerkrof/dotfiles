{ inputs, lib, ... }:

with lib;
with lib.my;
let 
sys = "x86_64-linux";
inherit (builtins) readDir;
in {
  mapNixosHostUsers = hostDir: homeDir: {
    users.users = mapAttrs
    (user: v: { 
      extraGroups = ["wheel" "audio" "video"];
      initialPassword = "nixos";
      isNormalUser = true;
      group = "users";
    })
    (filterAttrs (n: v: v == "directory") (readDir hostDir));
  };

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
      {
        nixpkgs.pkgs = pkgs;
        networking.hostName = mkDefault (baseNameOf hostDir);
      }
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
      "${hostDir}/default.nix"
      "${hostDir}/hardware-configuration.nix"
      ../modules/default.nix
      ../modules/nixos/default.nix
      (mapHostUsers hostDir "home")
      (mapNixosHostUsers hostDir "home")
      (mapHostUsersHome hostDir ../modules/home-manager "home" ../modules/options.nix)
    ] ++ (mapModulesRec' ../modules/nixos import);
  };
}
