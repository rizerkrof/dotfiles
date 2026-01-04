{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
with lib.my;
mkIf (elem "tailscale" config.modules.profiles.networks) (mkMerge [
  {
    services.tailscale.enable = true;
    networking.firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  }
])
