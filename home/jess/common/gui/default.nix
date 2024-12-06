{ pkgs, ... }:
{
  # home/jess/common/gui
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

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

  home.packages = with pkgs; [
    pcmanfm
    file-roller
    # aseprite - Animated sprite editor & pixel art tool
    # https://www.aseprite.org/
    aseprite
  ];

}
