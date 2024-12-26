{ config, pkgs, ... }:
{
  home = {
    username = "entertainment";
    homeDirectory = "/home/entertainment";
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
