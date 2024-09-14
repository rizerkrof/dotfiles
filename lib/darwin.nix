{lib, inputs, ...}:

with lib;
with lib.my;
let 
    inherit (builtins) readDir;
    darwinSystem = inputs.nix-darwin.lib.darwinSystem;
    options = ../home-manager/modules/options.nix;
in {
    mkDarwinHost = hostDir: system: darwinSystem {
        inherit system lib;
        modules = [
            inputs.home-manager.darwinModules.home-manager
            inputs.stylix.darwinModules.stylix
            "${hostDir}/default.nix"
            ../home-manager/modules/default.nix
            (mapHostUsersHome hostDir ../home-manager/modules/home-manager options)
        ] ++ (mapModulesRec' ../home-manager/modules/homebrew import);
    };
}
