{ pkgs, ... }:
{
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
    # Keepassxc menu for rofi
    # https://github.com/firecat53/keepmenu
    keepmenu

    ## Required for keepmenu
    # Python library to interact with keepass databases (supports KDBX3 and KDBX4)
    # https://github.com/libkeepass/pykeepass
    python312Packages.pykeepass
    # Command-line program for getting and setting the contents of the X selection
    xsel
    # Fake keyboard/mouse input, window management, and more
    # https://www.semicomplete.com/projects/xdotool/
    xdotool

    ## Possibly needed by rofi-calc
    # Advanced calculator library
    libqalculate
  ];
}
