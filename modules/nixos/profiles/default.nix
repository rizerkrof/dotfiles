{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
{
  options.modules.profiles = {
    networks = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of network names";
    };
  };
}
