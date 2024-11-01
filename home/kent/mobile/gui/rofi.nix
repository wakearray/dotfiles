{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override {
      plugins = with pkgs; [
        # Emoji picker for rofi
        #
        rofi-emoji

        # top functionality in rofi
        #
        rofi-top

        # Calculator for rofi
        #
        rofi-calc

        # Bluetooth configuration in rofi
        #
        rofi-bluetooth

        # Take screenshots with rofi
        #
        rofi-screenshot

        # A power menu for rofi
        #
        rofi-power-menu

        # todo.txt support in rofi
        #
        todofi-sh

        # Keepass menu for rofi
        #
        keepmenu
      ];
    };
    extraConfig = {
      modi = "drun,emoji,ssh,window,windowcd,run,combi,keys,filebrowser,top,calc";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
    };
    font = "SauceCodePro NFM 16";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "gruvbox-dark";
  };
}
