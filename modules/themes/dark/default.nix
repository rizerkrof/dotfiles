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
            black         = "#16161C"; # 0
            red           = "#E95678"; # 1
            green         = "#29D398"; # 2
            yellow        = "#FAB795"; # 3
            blue          = "#26BBD9"; # 4
            magenta       = "#EE64AE"; # 5
            cyan          = "#59E3E3"; # 6
            silver        = "#FADAD1"; # 7
            grey          = "#232530"; # 8
            brightred     = "#EC6A88"; # 9
            brightgreen   = "#3FDAA4"; # 10
            brightyellow  = "#FBC3A7"; # 11
            brightblue    = "#3FC6DE"; # 12
            brightmagenta = "#F075B7"; # 13
            brightcyan    = "#6BE6E6"; # 14
            white         = "#FDF0ED"; # 15

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
          "kitty/kitty.d/theme/colors.conf".text = ''
            color0 ${black}
            color1 ${red}
            color2 ${green}
            color3 ${yellow}
            color4 ${blue}
            color5 ${magenta}
            color6 ${cyan}
            color7 ${silver}
            color8 ${grey}
            color9 ${brightred}
            color10 ${brightgreen}
            color11 ${brightyellow}
            color12 ${brightblue}
            color13 ${brightmagenta}
            color14 ${brightcyan}
            color15 ${white}
          '';
          "kitty/kitty.d/theme/window.conf".text = ''
            background_opacity 0.65
            background ${grey}
            window_padding_width 12
            cursor ${red}
          '';
        })
      ];
    })
  ]);
}
