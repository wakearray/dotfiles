{ config, pkgs, ... }:
let
  user = config.home.username;
in
{
  imports = [
    ./common
    ../common
  ];

  home = {
    username = "entertainment";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";

    pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
    };
  };
}
