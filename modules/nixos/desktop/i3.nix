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
  redColor = builtins.substring 1 6 config.lib.stylix.colors.base08;
  greenColor = builtins.substring 1 6 config.lib.stylix.colors.base0B;

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

    # Low battery warning (red line)
    if [ "$CAPACITY" -lt 10 ] && [ "$STATUS" != "Charging" ]; then
      ${pkgs.i3}/bin/i3-msg 'fullscreen disable'
      ${pkgs.systemd}/bin/systemctl --user stop video-background 2>/dev/null || true
      if ! pgrep -f "conky.*battery-warning-conky.conf" > /dev/null; then
        ${pkgs.conky}/bin/conky -c ${conkyConfigRed} &
      fi
      # Kill green line if it's running
      ${pkgs.procps}/bin/pkill -f "conky.*battery-full-conky.conf" 2>/dev/null || true
    # Full battery indicator (green line)
    elif [ "$CAPACITY" -gt 99]; then
      ${pkgs.i3}/bin/i3-msg 'fullscreen disable'
      if ! pgrep -f "conky.*battery-full-conky.conf" > /dev/null; then
        ${pkgs.conky}/bin/conky -c ${conkyConfigGreen} &
      fi
      # Kill red line if it's running
      ${pkgs.procps}/bin/pkill -f "conky.*battery-warning-conky.conf" 2>/dev/null || true
    # Normal battery state
    else
      ${pkgs.procps}/bin/pkill -f "conky.*battery-warning-conky.conf" 2>/dev/null || true
      ${pkgs.procps}/bin/pkill -f "conky.*battery-full-conky.conf" 2>/dev/null || true
      
      # Start video-background if it's not running
      if ! ${pkgs.systemd}/bin/systemctl --user is-active --quiet video-background; then
        ${pkgs.systemd}/bin/systemctl --user start video-background 2>/dev/null || true
      fi
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
