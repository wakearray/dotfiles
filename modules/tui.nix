{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    
    # Terminal file managers
    # Yazi - Blazing fast terminal file manager written in Rust, based on async I/O
    # https://github.com/sxyazi/yazi
    yazi

    # Terminal UI for Systemd Logs and Status
    # https://crates.io/crates/systemctl-tui
    systemctl-tui

    # notcurses - blingful character graphics/TUI library. definitely not curses.
    # https://github.com/dankamongmen/notcurses
    notcurses

    # hyfetch - neofetch with pride flags
    hyfetch

    # mpv - General-purpose media player, fork of MPlayer and mplayer2
    # https://mpv.io/
    mpv
    # mpvc - A mpc-like control interface for mpv
    # https://github.com/lwilletts/mpvc
    mpvc

    # Lazycli - A tool to static turn CLI commands into TUIs
    # https://github.com/jesseduffield/lazycli
    lazycli

    # Oxker - A simple tui to view & control docker containers
    # https://github.com/mrjackwills/oxker
    oxker

    # GitUI provides you with the comfort of a git GUI but right in your terminal
    # https://github.com/extrawurst/gitui
    unstable.gitui

    # Stress-Terminal UI, s-tui, monitors CPU temperature, frequency, power and utilization in a graphical way from the terminal.
    # https://amanusk.github.io/s-tui/
    unstable.s-tui

    # yt-dlp - Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    # https://github.com/yt-dlp/yt-dlp/
    yt-dlp

    # An aesthetically pleasing YouTube TUI written in Rust
    # https://github.com/Siriusmart/youtube-tui
    youtube-tui

  ];
}
