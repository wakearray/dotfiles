{ inputs, lib, config, pkgs, ... }:
let
  system = config.home.systemDetails.architecture.text;
in
{
  # kent/common/gui
  # All settings and packages should be compatible with Android profiles
  imports = [
    ./firefox.nix
    ./mime.nix
    ./ssh.nix
  ];

  config = lib.mkIf config.gui.enable {
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
      rofi = {
        enable = true;
        plugins = with pkgs; [
          # Emoji picker for rofi
          # https://github.com/Mange/rofi-emoji
          rofi-emoji
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
      # A FOSS PDF Editor
      # https://github.com/JakubMelka/PDF4QT
      pdf4qt

      # LibreOffice, a FOSS MS Office clone
      # https://www.libreoffice.org/about-us/source-code/
      libreoffice-qt6

      # Scriptable music downloader for Qobuz, Tidal, SoundCloud, and Deeze
      # https://github.com/nathom/streamrip
      streamrip
    ] ++ [ inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default ];
  };
}
