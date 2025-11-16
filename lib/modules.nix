{ self, lib, ... }:

let
  inherit (builtins)
    attrValues
    readDir
    pathExists
    concatLists
    ;
  inherit (lib)
    id
    mapAttrsToList
    filterAttrs
    hasPrefix
    hasSuffix
    nameValuePair
    removeSuffix
    ;
  inherit (self.attrs) mapFilterAttrs;
in
rec {
  mapModules =
    dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (
      n: v:
      let
        path = "${toString dir}/${n}";
      in
      if v == "regular" && n != "default.nix" && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null
    ) (readDir dir);

  mapModules' = dir: fn: attrValues (mapModules dir fn);

  mapModulesRec =
    dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (
      n: v:
      let
        path = "${toString dir}/${n}";
      in
      if v == "directory" then
        nameValuePair n (mapModulesRec path fn)
      else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null
    ) (readDir dir);

  mapModulesRec' =
    dir: fn:
    let
      default =
        let
          p = "${dir}/default.nix";
        in
        if pathExists p then [ dir ] else [ ];
      dirs = mapAttrsToList (k: _: "${dir}/${k}") (
        filterAttrs (n: v: v == "directory" && !(hasPrefix "_" n)) (readDir dir)
      );
      files = attrValues (mapModules dir id);
      paths = default ++ files ++ concatLists (map (d: mapModulesRec' d id) dirs);
    in
    map fn paths;
}
