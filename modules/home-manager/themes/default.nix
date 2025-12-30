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
  themesDir = config.dotfiles.themesDir;
  themes = [
    "night-session"
    "morning-bites"
  ];
in
{
  home.dataFile = genAttrs themes (name: {
    source = "${themesDir}/${name}";
    recursive = true;
  });
}
