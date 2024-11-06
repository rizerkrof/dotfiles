{ lib, ... }:

with lib;
with lib.my;
let
  inherit (builtins) readDir;
in
{
  mapHosts' =
    hostsTypeDir:
    let
      hostsNamesOfSystems = mapAttrs (system: _: (readDir "${toString hostsTypeDir}/${system}")) (
        readDir hostsTypeDir
      ); # { hostTypeSystem: { hostName: "directory", ... }, ... }

      systemOfHosts = lib.foldl' (
        hostsSystem: system:
        let
          hostsNames = hostsNamesOfSystems.${system}; # { hostName: "directory", ... }
        in
        hostsSystem
        // lib.foldl' (
          hostsSystem: hostName:
          hostsSystem
          // {
            ${hostName} = {
              inherit system;
            };
          }
        ) { } (lib.attrNames hostsNames)
      ) { } (lib.attrNames hostsNamesOfSystems); # { hostName: { system: "aarch64-darwin" }, ... }
    in
    if hasSuffix "darwin" hostsTypeDir then
      mapHostsOfType systemOfHosts mkDarwinHost hostsTypeDir
    else if hasSuffix "nixos" hostsTypeDir then
      mapHostsOfType systemOfHosts mkNixosHost hostsTypeDir
    else
      { };

  mapHostsOfType =
    systemOfHosts: mkHost: hostsTypeDir:
    mapAttrs (
      hostName: hostInfo: mkHost "${toString hostsTypeDir}/${hostInfo.system}/${hostName}" hostInfo.system
    ) systemOfHosts;

  mapHostUsers = hostDir: homeDir: {
    users.users = mapAttrs (user: v: {
      home = "/${homeDir}/${user}";
    }) (filterAttrs (n: v: v == "directory") (readDir hostDir));
  };
}
