{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "dark") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.jpg;
        };
      };
    }


    # Desktop X11 theming
    (mkIf config.services.xserver.enable {
      # Compositor
      services.picom = {
        settings = {
          blur = { 
          method = "gaussian";
          size = 50;
          deviation = 30.0;
          };
        };
      };
    })
  ]);
}
