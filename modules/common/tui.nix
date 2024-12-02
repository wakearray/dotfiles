{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    # https://github.com/hykilpikonna/HyFetch
    hyfetch

    # Lazycli - A tool to static turn CLI commands into TUIs
    # https://github.com/jesseduffield/lazycli
    lazycli

    # Oxker - A simple tui to view & control docker containers
    # https://github.com/mrjackwills/oxker
    oxker

    # GitUI provides you with the comfort of a git GUI but right in your terminal
    # https://github.com/extrawurst/gitui
    unstable.gitui
  ];
}
