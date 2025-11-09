{ lib, inputs, ... }:

with lib;
with lib.my;
let
  inherit (builtins) readDir;
  darwinSystem = inputs.nix-darwin.lib.darwinSystem;
  options = ../modules/options.nix;
in
{
  mkDarwinHost =
    hostDir: system:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    darwinSystem {
      inherit system lib;
      modules = [
        inputs.mac-app-util.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        inputs.stylix.darwinModules.stylix
        "${hostDir}/default.nix"
        ../modules/default.nix
        ../modules/darwin/default.nix
        (mapHostUsers hostDir "Users")
        (mapHostUsersHome pkgs hostDir ../modules/home-manager "Users" options)
      ]
      ++ (mapModulesRec' ../modules/darwin import);
    };
}
