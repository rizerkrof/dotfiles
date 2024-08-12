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
            "${hostDir}/default.nix"
            ../home-manager/modules/home-manager/default.nix
            inputs.home-manager.darwinModules.home-manager
            (mapHostUsers hostDir ../home-manager/modules)
        ] ++ (mapModulesRec' ../home-manager/modules/homebrew import);
    };
}
