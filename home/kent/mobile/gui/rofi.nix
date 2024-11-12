{ pkgs, ... }:
{
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi.override {
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

          # Bluetooth configuration in rofi
          #
          #rofi-bluetooth
        ];
      };
      extraConfig = {
        modi = "drun,todo:todofi.sh,calc,top,filebrowser,keys";
        kb-primary-paste = "Control+V,Shift+Insert";
        kb-secondary-paste = "Control+v,Insert";
      };
      font = "SauceCodePro NFM 16";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = "gruvbox-dark";
    };

    zsh.sessionVariables = {
      ROFI_SCREENSHOT_DATE_FORMAT = "+%Y-%m-%d-%H-%M-%S";
    };
  };

  home.packages = with pkgs; [
      # Keepassxc menu for rofi
      # https://github.com/firecat53/keepmenu
      keepmenu

      ## Required for keepmenu
      # Python library to interact with keepass databases (supports KDBX3 and KDBX4)
      # https://github.com/libkeepass/pykeepass
      unstable.python312Packages.pykeepass
      # Command-line program for getting and setting the contents of the X selection
      xsel
      # Fake keyboard/mouse input, window management, and more
      # https://www.semicomplete.com/projects/xdotool/
      xdotool

      # Take screenshots with rofi
      # https://github.com/ceuk/rofi-screenshot
      rofi-screenshot

      ## Required for rofi-screenshot
      # Queries a selection from the user and prints to stdout
      slop
      # Run commands on rectangular screen regions
      ffcast
      # Tool to access the X clipboard from a console application
      xclip

      # A power menu for rofi
      # Shows a Power/Lock menu with Rofi
      # https://github.com/jluttine/rofi-power-menu
      #rofi-power-menu
      # Add `power-menu:rofi-power-menu` to `modi=` to enable

      ## Possibly needed by rofi-calc
      # Advanced calculator library
      libqalculate
  ];
}
