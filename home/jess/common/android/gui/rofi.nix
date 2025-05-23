{ lib, config, pkgs, ... }:
let
  agui = config.android.gui;
  x11 = config.home.systemDetails.display.x11;
in
{
  # Rofi config for Android using Termux:X11
  config = lib.mkIf (agui.enable && x11) {
    gui.rofi = {
      enable = true;
      plugins = with pkgs; [
        # Emoji picker for rofi
        # https://github.com/Mange/rofi-emoji
        rofi-emoji

        # An interface for top inside rofi
        # https://github.com/davatorium/rofi-top
        rofi-top

        # Calculator for rofi
        # https://github.com/svenstaro/rofi-calc
        rofi-calc
      ];
      modi = "drun,todo:todofi.sh,calc,top,filebrowser,keys";
    };

    home.packages = with pkgs; [
      # Command-line program for getting and setting the contents of the X selection
      xsel
      # Fake keyboard/mouse input, window management, and more
      # https://www.semicomplete.com/projects/xdotool/
      xdotool

      ## Possibly needed by rofi-calc
      # Advanced calculator library
      libqalculate
    ];
  };
}
