{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = themeConfigValue: let themeEnvValue = builtins.getEnv "THEME"; in
      if themeEnvValue != "" then themeEnvValue else themeConfigValue;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable.
      '';
    };

    wallpaper = mkOption {
      type = nullOr path;
      default = null;
    };  

    onReload = mkOption {
      type = attrsOf lines;
      default = {};
    };

    colors = {
      black         = mkOpt str "#000000"; # 0
      red           = mkOpt str "#FF0000"; # 1
      green         = mkOpt str "#00FF00"; # 2
      yellow        = mkOpt str "#FFFF00"; # 3
      blue          = mkOpt str "#0000FF"; # 4
      magenta       = mkOpt str "#FF00FF"; # 5
      cyan          = mkOpt str "#00FFFF"; # 6
      silver        = mkOpt str "#BBBBBB"; # 7
      grey          = mkOpt str "#888888"; # 8
      brightred     = mkOpt str "#FF8888"; # 9
      brightgreen   = mkOpt str "#88FF88"; # 10
      brightyellow  = mkOpt str "#FFFF88"; # 11
      brightblue    = mkOpt str "#8888FF"; # 12
      brightmagenta = mkOpt str "#FF88FF"; # 13
      brightcyan    = mkOpt str "#88FFFF"; # 14
      white         = mkOpt str "#FFFFFF"; # 15

      # Color classes
      types = {
        bg        = mkOpt str cfg.colors.black;
        fg        = mkOpt str cfg.colors.white;
        panelbg   = mkOpt str cfg.colors.types.bg;
        panelfg   = mkOpt str cfg.colors.types.fg;
        border    = mkOpt str cfg.colors.types.bg;
        error     = mkOpt str cfg.colors.red;
        warning   = mkOpt str cfg.colors.yellow;
        highlight = mkOpt str cfg.colors.white;
      };
    };
  };

  config = mkIf (cfg.active != null) (mkMerge [
    (mkIf (cfg.wallpaper != null)
    # Set the wallpaper ourselves so we don't need .background-image and/or
    # .fehbg polluting $HOME
    (let wCfg = config.services.xserver.desktopManager.wallpaper;
    command = ''
      if [ -e "$XDG_DATA_HOME/wallpaper" ]; then
      ${pkgs.feh}/bin/feh --bg-${wCfg.mode} \
      ${optionalString wCfg.combineScreens "--no-xinerama"} \
      --no-fehbg \
      $XDG_DATA_HOME/wallpaper
      fi
    '';
    in {
      services.xserver.displayManager.sessionCommands = command;
      modules.theme.onReload.wallpaper = command;

      home.dataFile = mkIf (cfg.wallpaper != null) {
        "wallpaper".source = cfg.wallpaper;
      };
    }))

    (mkIf (cfg.onReload != {})
    (let reloadTheme =
      with pkgs; (writeScriptBin "reloadTheme" ''
        #!${stdenv.shell}
        echo "Reloading current theme: ${cfg.active}"
        ${concatStringsSep "\n"
        (mapAttrsToList (name: script: ''
          echo "[${name}]"
          ${script}
        '') cfg.onReload)}
      '');
    in {
      user.packages = [ reloadTheme ];
      system.userActivationScripts.reloadTheme = ''
        [ -z "$NORELOAD" ] && ${reloadTheme}/bin/reloadTheme
      '';
    }))
  ]);
}
