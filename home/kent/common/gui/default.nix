{ inputs, lib, config, pkgs, ... }:
let
  gui = config.gui;
  wayland = config.gui.wayland;
  system = config.home.systemDetails.architecture.text;
in
{
  # kent/common/gui
  # All settings and packages should be compatible with Android profiles

  config = lib.mkIf gui.enable {
    # maybe want this: GTK_THEME=Arc-Dark file-roller
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    gui = {
      themes.gruvbox.enable = true;
      rofi = lib.mkIf (wayland.enable) {
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
      todo = {
        enable = true;
        todofi.enable = true;
      };
      firefox.enable = true;
    };

    home.packages = with pkgs; [
      # File manager
      pcmanfm
      # Archive manager
      file-roller
      # Bluetooth GUI written in Rust
      overskride
    ] ++ [ inputs.zen-browser.packages."${system}".default ];
  };
}
