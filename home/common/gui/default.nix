{ pkgs, system-details, ... }:
{
  imports = [
    ./alacritty.nix
    ./mpv.nix
    ./rofi.nix
    ./wthrr.nix

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
      unstable.keepassxc
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
