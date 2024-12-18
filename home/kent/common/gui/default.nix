{ pkgs, ... }:
{
  # kent/common/gui
  imports = [
    ./alacritty.nix
    ./fonts.nix
    ./gurk.nix
    ./todo.nix
    ../../../themes/gruvbox
  ];

  # maybe want this: GTK_THEME=Arc-Dark file-roller
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
  ];
}
