{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Defaults for any GUI specific applications that I want on every GUI capable computer
  imports = [
    ./sound.nix
  ];

  environment.systemPackages = with pkgs; [
    # Rust based teamviewer
    rustdesk-flutter

    # mpvc - A mpc-like control interface for mpv
    # https://github.com/lwilletts/mpvc
    mpvc

    # yt-dlp - Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    # https://github.com/yt-dlp/yt-dlp/
    yt-dlp

    # An aesthetically pleasing YouTube TUI written in Rust
    # https://github.com/Siriusmart/youtube-tui
    youtube-tui
  ];

  fonts.packages = with pkgs; [
    # Better emojis
    twemoji-color-font

    # Nerdfonts
    unstable.nerdfonts
  ];
}
