{
  config,
  options,
  pkgs,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.shell.nushell;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.nushell = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    xdg.enable = true;

    programs.nushell = {
      enable = true;

      configFile = {
        source = "${configDir}/nushell/config.nu";
      };

      envFile = {
        source = "${configDir}/nushell/env.nu";
      };

      shellAliases = {
        e = "echo";
        la = "ls -a";
        l = "ls";
      };
    };

    programs.carapace.enable = true;
    programs.carapace.enableNushellIntegration = true;

    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    home.configFile.nushell = {
      source = "${configDir}/nushell";
      recursive = true;
    };
  };
}
