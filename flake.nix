{
  description = "A grossly incandescent nixos config.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable"; # for packages on the edge
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib.extend (
        self: super: {
          my = import ./lib {
            inherit inputs;
            lib = self;
          };
        }
      );
      inherit (lib.my)
        mapModules
        mapModulesRec
        mapHosts
        mapDarwinHosts
        mapHosts'
        ;
    in
    {
      lib = lib.my;
      nixosConfigurations = mapHosts' ./hosts/nixos;
      darwinConfigurations = mapHosts' ./hosts/darwin;
    };
}
