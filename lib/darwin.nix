{lib, inputs, ...}:

with lib;
with lib.my;
let 
    inherit (builtins) readDir;
    darwinSystem = inputs.nix-darwin.lib.darwinSystem;
in {
    mkDarwinHost = hostDir: system: darwinSystem {
        inherit system lib;
        modules = [
            inputs.home-manager.darwinModules.home-manager
            inputs.stylix.darwinModules.stylix
            "${hostDir}/default.nix"
            ../home-manager/modules/home-manager/default.nix
            (mapHostUsers hostDir ../home-manager/modules)
        ] ++ (mapModulesRec' ../home-manager/modules/homebrew import);
    };
}
