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
      pcmanfm.enable = true;
    };

    home.packages = with pkgs; [
      # Bluetooth GUI written in Rust
      # https://github.com/kaii-lb/overskride
      overskride

      # A FOSS PDF Editor
      # https://github.com/JakubMelka/PDF4QT
      pdf4qt

      # LibreOffice, a FOSS MS Office clone
      # https://www.libreoffice.org/about-us/source-code/
      libreoffice-qt6
    ] ++ [ inputs.zen-browser.packages."${system}".default ];
  };
}
