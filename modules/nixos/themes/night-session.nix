{
  options,
  config,
  lib,
  pkgs,
  themesDir,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.theme.night-session;
  wallpaperPath = themesDir + /night-session/wallpaper.png;
in
{
  options.modules.theme.night-session = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xwinwrap
      mpv
      feh
      (pkgs.writeShellScriptBin "reload-theme" ''
        #!/usr/bin/env bash
        set -e

        echo "Reloading theme..."
        # Reload wallpaper because stylix does not hot swap wallpaper
        ${pkgs.feh}/bin/feh --bg-scale ${wallpaperPath} && echo "✓ wallpaper reloaded"
        systemctl --user restart video-background && echo "✓ video-background restarted"
        systemctl --user restart picom && echo "✓ picom restarted"
        echo "Theme reload complete!"
      '')
      (pkgs.writeShellScriptBin "theme-min" ''
        #!/usr/bin/env bash
        set -e

        echo "Setting minimal theme..."
        # Reload wallpaper because stylix does not hot swap wallpaper
        ${pkgs.feh}/bin/feh --bg-scale ${wallpaperPath} && echo "✓ wallpaper reloaded"
        systemctl --user stop video-background && echo "✓ video-background stopped"
        systemctl --user stop picom && echo "✓ picom stopped"
        echo "Minimal theme complete!"
      '')
    ];

    stylix = {
      enable = true;
      image = wallpaperPath;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      targets.feh.enable = true;
    };

    services = {
      picom = {
        enable = true;
        backend = "glx"; # or "xrender" if GLX is problematic
        vSync = true;
        # inactiveOpacity = 0.7;
        # activeOpacity = 0.8;
        inactiveOpacity = 0.9;
        activeOpacity = 0.94;
        settings = {
          corner-radius = 12;
          frame-opacity = 0.7;
          blur = {
            method = "dual_kawase";
            size = 10;
            strength = 5;
          };
        };
      };
    };

    systemd.user.services.video-background = {
      description = "Animated video background on root window";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      restartIfChanged = true;
      reloadIfChanged = true;

      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        ExecStart = ''
          ${pkgs.xwinwrap}/bin/xwinwrap -s -nf -b -fs -st -sp -ov -- \
          ${pkgs.mpv}/bin/mpv \
            -wid WID \
            --loop \
            --really-quiet \
            --no-audio \
            --no-osc \
            --no-osd-bar \
            --no-input-default-bindings \
            --no-input-cursor \
            --cursor-autohide=always \
            --framedrop=vo \
            --panscan=1.0 \
            %h/.local/share/night-session/live.mp4
        '';
        Restart = "always";
        RestartSec = 5;
        Environment = [
          "DISPLAY=:0"
        ];
      };
    };
  };
}
