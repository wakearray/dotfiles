{ pkgs, system-details, ... }:
{
  # home/common/gui
  imports = [
    ./alacritty.nix
    ./cliphist.nix
    ./mpv.nix
    ./rofi.nix
    ./wthrr.nix
    ./eww
    ./vscode.nix
    ./fonts.nix
    ./firefox.nix
    (
      if
        builtins.match "wayland" system-details.display-type != null
      then
        ./wayland
      else
        ./x11
    )
    (
      if
        builtins.match "aarch64-linux" system-details.current-system != null
      then
        ./aarch64-gui.nix
      else
        ./x86_64-gui.nix
    )
  ];

  home = {
    packages = with pkgs; [
      # Keepassxc - Offline password store
      keepassxc

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
}
