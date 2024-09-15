{lib, inputs, ...}:

with lib;
with lib.my;
let 
inherit (builtins) readDir;
darwinSystem = inputs.nix-darwin.lib.darwinSystem;
options = ../modules/options.nix;
in {
  mkDarwinHost = hostDir: system: darwinSystem {
    inherit system lib;
    modules = [
      inputs.home-manager.darwinModules.home-manager
      inputs.stylix.darwinModules.stylix
      "${hostDir}/default.nix"
      ../modules/default.nix
      (mapHostUsersHome hostDir ../modules/home-manager "Users" options)
    ] ++ (mapModulesRec' ../modules/homebrew import);
  };
}
