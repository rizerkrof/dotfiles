{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.i3;

  # Strip the # from hex colors for conky
  redColor = lib.removePrefix "#" config.lib.stylix.colors.base08;
  greenColor = lib.removePrefix "#" config.lib.stylix.colors.base0B;

  # Red warning conky for low battery
  conkyConfigRed = pkgs.writeText "battery-warning-conky.conf" ''
    conky.config = {
          alignment = 'top_right',
          background = false,
          border_width = 0,
          default_color = '${redColor}',
          draw_borders = false,
          use_xft = true,
          font = 'monospace:size=1',
          gap_x = 0,
          gap_y = 0,
          minimum_height = 2,
          minimum_width = 10000,
          own_window = true,
          own_window_class = 'battery-warning-right',
          own_window_type = 'override',
          own_window_transparent = false,
          own_window_colour = '${redColor}',
          out_to_x = true,
          out_to_wayland = false,
          update_interval = 60.0,
          double_buffer = true,
        }
        conky.text = [[]]
  '';

  # Green conky for full battery
  conkyConfigGreen = pkgs.writeText "battery-full-conky.conf" ''
    conky.config = {
          alignment = 'top_right',
          background = false,
          border_width = 0,
          default_color = '${greenColor}',
          draw_borders = false,
          use_xft = true,
          font = 'monospace:size=1',
          gap_x = 0,
          gap_y = 0,
          minimum_height = 2,
          minimum_width = 10000,
          own_window = true,
          own_window_class = 'battery-full-right',
          own_window_type = 'override',
          own_window_transparent = false,
          own_window_colour = '${greenColor}',
          out_to_x = true,
          out_to_wayland = false,
          update_interval = 60.0,
          double_buffer = true,
        }
        conky.text = [[]]
  '';

  batteryCheckScript = pkgs.writeShellScriptBin "battery-warning-check" ''
    #!/usr/bin/env bash
    BATTERY_PATH="/sys/class/power_supply/BAT0"
    CAPACITY=$(cat $BATTERY_PATH/capacity 2>/dev/null || echo 100)
    STATUS=$(cat $BATTERY_PATH/status 2>/dev/null || echo "Unknown")

    # Fonction pour tuer tous les processus conky liés
    kill_conky() {
      echo "KILL"
      ${pkgs.procps}/bin/pkill -9 -f "conky.*battery-warning-conky.conf" 2>/dev/null || true
      ${pkgs.procps}/bin/pkill -9 -f "conky.*battery-full-conky.conf" 2>/dev/null || true
      sleep 0.3
    }

    # Low battery warning (red line)
    if [ "$CAPACITY" -lt 10 ] && [ "$STATUS" != "Charging" ]; then
      ${pkgs.systemd}/bin/systemctl --user stop video-background 2>/dev/null || true
      ${pkgs.i3}/bin/i3-msg 'fullscreen disable'

      kill_conky
      ${pkgs.conky}/bin/conky -c ${conkyConfigRed} &

      echo "CRITICAL"
    # Full battery indicator (green line)
    elif [ "$CAPACITY" -gt 98 ] && ( [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ] ); then
      ${pkgs.systemd}/bin/systemctl --user stop video-background 2>/dev/null || true
      ${pkgs.i3}/bin/i3-msg 'fullscreen disable'

      kill_conky
      ${pkgs.conky}/bin/conky -c ${conkyConfigGreen} &

      echo "FULL"
    # Normal battery state
    else
      kill_conky
      
      # Start video-background if it's not running
      if ! ${pkgs.systemd}/bin/systemctl --user is-active --quiet video-background; then
        ${pkgs.systemd}/bin/systemctl --user start video-background 2>/dev/null || true
      fi

      echo "NORMAL"
    fi
  '';
in
{
  options.modules.desktop.i3 = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      conky
      batteryCheckScript
    ];
    # Create systemd user service for battery monitoring
    systemd.user.services.battery-warning-line = {
      description = "Battery warning red line indicator";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do ${batteryCheckScript}/bin/battery-warning-check; sleep 5; done'";
        Restart = "on-failure";
        RestartSec = 5;
        Environment = [ "DISPLAY=:0" ];
      };
    };
    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
    };
  };
}
