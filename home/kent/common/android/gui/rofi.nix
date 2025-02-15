{ lib, config, pkgs, ... }:
let
  agui = config.android.gui;
in
{
  config = lib.mkIf agui.enable {
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
      #modi = "drun,calc,top,filebrowser,keys";
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
