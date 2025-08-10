{ inputs, lib, config, pkgs, ... }:
let
  gui = config.gui;
  wayland = config.gui.wayland;
  system = config.home.systemDetails.architecture.text;
in
{
  # kent/common/gui
  # All settings and packages should be compatible with Android profiles
  imports = [
    ./firefox.nix
    ./ssh.nix
  ];

  config = lib.mkIf gui.enable {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      font = {
        name = "SauceCodePro NFM";
      };
    };

    gui = {
      themes.gruvbox.enable = true;
      rofi = lib.mkIf (wayland.enable) {
        enable = true;
        plugins = with pkgs; [
          # Emoji picker for rofi - Built against rofi-wayland
          # https://github.com/Mange/rofi-emoji
          rofi-emoji-wayland
        ];
        modi = "drun,todo:todofi.sh";
      };
      todo = {
        enable = true;
        todofi.enable = true;
      };
      pcmanfm.enable = true;
      alacritty.enable = true;
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
