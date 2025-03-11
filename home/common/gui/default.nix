{ pkgs, lib, config, ... }:
let
  sd = config.home.systemDetails.display;
in
{
  # home/common/gui
  imports = [
    ./alacritty.nix
    ./cliphist.nix
    ./eww
    ./firefox.nix
    ./fonts.nix
    ./mpv.nix
    ./rofi.nix
    ./scripts
    ./themes
    ./todo
    ./tui.nix
    ./vscode.nix
    ./wayland
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

        # Waiting on pull request to be accepted
        # https://github.com/NixOS/nixpkgs/pull/384032
        # Signal Messenger for desktop
        #signal-desktop

        glmark2
      ];
    };

    programs = {
      # yt-dlp - A feature-rich command-line audio/video downloader
      # https://github.com/yt-dlp/yt-dlp#configuration
      yt-dlp = {
        enable = true;
        # TODO: Fill in the settings later
      };
    };
  };
}
