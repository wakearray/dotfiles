{ lib, pkgs, config, ... }:
let
  gui = config.gui;
in
{
  # home/jess/common/gui
  # Programs and settings for all hosts using a GUI
  config = lib.mkIf gui.enable {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    home.packages = with pkgs; [
      pcmanfm
      file-roller
      # aseprite - Animated sprite editor & pixel art tool
      # https://www.aseprite.org/
      aseprite
    ];
  };
}
