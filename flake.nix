# flake.nix --- the heart of my dotfiles
#
# Author:  Henrik Lissner <contact@henrik.io>
# URL:     https://github.com/hlissner/dotfiles
# License: MIT
#
# Welcome to ground zero. Where the whole flake gets set up and all its modules
# are loaded.

{
  description = "A grossly incandescent nixos config.";

  inputs = 
  {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable";             # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";  # for packages on the edge
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
  let
    inherit (lib.my) mapModules mapModulesRec mapHosts;

    system = "x86_64-linux";

    mkPkgs = pkgs: extraOverlays: import pkgs {
      inherit system;
      config.allowUnfree = true;  # forgive me Stallman senpai
    };
    pkgs  = mkPkgs nixpkgs [ self.overlay ];
    pkgs' = mkPkgs nixpkgs-unstable [];

    lib = nixpkgs.lib.extend(self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
  in {
    lib = lib.my;

    overlay = final: prev: {
      unstable = pkgs';
      my = self.packages."${system}";
    };

    nixosModules = { dotfiles = import ./.; } // mapModulesRec ./modules import;

    nixosConfigurations = mapHosts ./hosts {};
  };
}
