{ lib, pkgs, config, ... }:
let
  wayland = config.gui.wayland;
  isAndroid = config.home.systemDetails.isAndroid;
in
{
  # A rofi config for NixOS systems using Wayland
  config = lib.mkIf (wayland.enable && (!isAndroid)) {
    gui.rofi = {
      enable = true;
      plugins = with pkgs; [

        # Bluetooth configuration in rofi
        # https://github.com/nickclyde/rofi-bluetooth
        rofi-bluetooth

        # Emoji picker for rofi
        # https://github.com/Mange/rofi-emoji
        rofi-emoji
      ];

      modi = "drun,todo:todofi.sh,filebrowser,emoji";
    };
  };
}
