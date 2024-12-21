{ pkgs, ... }:
{
  # home/jess/cichlid
  imports = [
    ../../themes/catppuccin
    ./starship.nix
    ./gnome.nix
  ];

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
}
