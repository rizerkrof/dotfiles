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
