{ lib, pkgs, system-details, ... }:
{
  # A rofi config for NixOS systems using Wayland
  config = lib.mkIf (builtins.match "wayland" system-details.display-type != null) {
    gui.rofi = {
      enable = true;
      plugins = with pkgs; [

        # Bluetooth configuration in rofi
        # https://github.com/nickclyde/rofi-bluetooth
        rofi-bluetooth

        # Emoji picker for rofi - Built against rofi-wayland
        # https://github.com/Mange/rofi-emoji
        rofi-emoji-wayland
      ];
      modi = "drun,todo:todofi.sh,filebrowser,emoji";
    };
  };
}
