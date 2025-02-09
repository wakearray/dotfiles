{ pkgs, lib, config, system-details, ... }:
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
    ./tui.nix
    ./vscode.nix
    ./wayland
    ./wthrr.nix
    ./x86_64-gui.nix
  ];

  options.gui = with lib; {
    enable = mkOption {
      type = types.bool;
      default = ((builtins.match "x11" system-details.display-type != null) || (builtins.match "wayland" system-details.display-type != null));
      description = "Default `true` if `system-details.display-type` is set to `x11` or `wayland` in `flake.nix`.";
    };
  };

  config = lib.mkIf config.gui.enable {
    home = {
      packages = with pkgs; [
        # Video player
        vlc

        # Utilities for managing home files
        xdg-utils

        # Signal Messenger for desktop
        signal-desktop
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
