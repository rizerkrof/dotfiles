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
          colors = {
            black         = "#000000"; # 0
            red           = "#D85153"; # 1
            green         = "#00FF00"; # 2
            yellow        = "#FFFF00"; # 3
            blue          = "#0000FF"; # 4
            magenta       = "#FF00FF"; # 5
            cyan          = "#00FFFF"; # 6
            silver        = "#BBBBBB"; # 7
            grey          = "#888888"; # 8
            brightred     = "#FF8888"; # 9
            brightgreen   = "#00FF80"; # 10
            brightyellow  = "#FFFF88"; # 11
            brightblue    = "#0088FF"; # 12
            brightmagenta = "#FF88FF"; # 13
            brightcyan    = "#88FFFF"; # 14
            white         = "#FFFFFF"; # 15

            # Color classes
            types = with cfg.colors; {
              bg        = black;
              fg        = white;
              panelbg   = bg;
              panelfg   = fg;
              border    = bg;
              error     = red;
              warning   = yellow;
              highlight = white;
            };
          };
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

      # Other dotfiles
      home.configFile = with config.modules; with theme.colors; mkMerge [
        (mkIf desktop.term.kitty.enable {
          "kitty/kitty.d/theme.conf".text = ''
            background_opacity 0.65
            cursor ${red}
          '';
        })
      ];
    })
  ]);
}
