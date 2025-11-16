{
  config,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.dev;
in
{
  options.modules.dev = with types; {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };
    };
  };
}
