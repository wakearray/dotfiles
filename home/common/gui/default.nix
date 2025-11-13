{ pkgs, lib, config, ... }:
let
  sd = config.home.systemDetails.display;
in
{
  # home/common/gui
  imports = [
    ./alacritty.nix
    ./cliphist.nix
    ./firefox.nix
    ./fonts.nix
    ./kitty.nix
    ./llm.nix
    ./mpv.nix
    ./pcmanfm.nix
    ./rofi
    ./scripts
    ./themes
    ./todo
    ./tui.nix
    ./vscode.nix
    ./wayland
    ./widgets
    ./wthrr.nix
    ./x11
    ./x86_64-gui.nix
  ];

  options.gui = with lib; {
    enable = mkOption {
      type = types.bool;
      default = (sd.wayland || sd.x11);
      description = "Default `true` if `systemDetails.display` is set to `x11` or `wayland` in `flake.nix`.";
    };
  };

  config = lib.mkIf config.gui.enable {
    home = {
      packages = with pkgs; [
        # Video player
        vlc

        # Utilities for managing home files
        xdg-utils

        # Graphics tests to assist with troubleshooting driver issues
        glmark2

        # A pretty aria2 client
        varia

        # The only Linux program I could find with a logical way to edit PDFs
        masterpdfeditor4
      ];
    };

    programs = {
      wthrr.enable = true;
      # yt-dlp - A feature-rich command-line audio/video downloader
      # https://github.com/yt-dlp/yt-dlp#configuration
      yt-dlp = {
        enable = true;
        # TODO: Fill in the settings later
      };
    };
    services = {
      # Removable disk automounter for udisks
      udiskie.enable = true;
    };
  };
}
