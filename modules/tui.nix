{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    rustdesk
    # 7-zip
    p7zip

    # Git
    git

    # Rust grep use `rg`
    repgrep
    ripgrep
    ripgrep-all

    # lsd - The next gen ls command
    # https://github.com/lsd-rs/lsd
    unstable.lsd

    # Zoxide - A fast cd command that learns your habits
    # https://github.com/ajeetdsouza/zoxide
    # https://www.youtube.com/watch?v=aghxkpyRVDY
    unstable.zoxide

    # fzf - Command-line fuzzy finder written in Go
    # https://github.com/junegunn/fzf
    fzf

    # Terminal file managers
    # https://github.com/antonmedv/walk
    walk
    # https://github.com/dzfrias/projectable
    projectable
    # https://github.com/GiorgosXou/TUIFIManager
    tuifimanager
    # Yazi - Blazing fast terminal file manager written in Rust, based on async I/O
    # https://github.com/sxyazi/yazi
    yazi
    # xplr - A hackable, minimal, fast TUI file explorer
    # https://xplr.dev/
    xplr
    # Terminal UI for Systemd Logs and Status
    # https://crates.io/crates/systemctl-tui
    systemctl-tui

    # Starship - A minimal, blazing fast, and extremely customizable prompt for any shell
    # https://starship.rs/
    unstable.starship

    # notcurses - blingful character graphics/TUI library. definitely not curses.
    # https://github.com/dankamongmen/notcurses
    notcurses

    ## Neovim
    unstable.neovim
    ## Find more plugins here:
    ## https://search.nixos.org/packages?channel=unstable&show=vimPlugins.edge&from=0&size=50&sort=relevance&type=packages&query=vimPlugins.
    # Plugin for zellij
    unstable.vimPlugins.zellij-nvim
    # Nodejs extension host for vim & neovim,
    # load extensions like VSCode and host language servers.
    unstable.vimPlugins.coc-nvim
    # Plugin for adding Rust Language Server
    unstable.vimPlugins.coc-rls
    # Plugin for adding Rust analyzer support
    unstable.vimPlugins.coc-rust-analyzer
    # Plugin for adding Bash Language Server
    unstable.vimPlugins.coc-sh
    # Plugin for adding fzf fuzzy searching
    unstable.vimPlugins.coc-fzf
    # Plugin for adding Git support
    unstable.vimPlugins.coc-git
    # Plugin for adding YAML support
    unstable.vimPlugins.coc-yaml
    # Plugin for adding TOML support
    unstable.vimPlugins.coc-toml
    # Plugin for adding LaTeX and markdown support
    unstable.vimPlugins.coc-ltex
    # Plugin for adding JSON support
    unstable.vimPlugins.coc-json
    # Plugin for adding HTML support
    unstable.vimPlugins.coc-html
    # Plugin for adding Common lists
    # https://github.com/neoclide/coc-lists#readme
    unstable.vimPlugins.coc-lists
    # Plugin for adding Tab9 AI autocomplete
    unstable.vimPlugins.coc-tabnine
    # Plugin for adding a folders pane
    unstable.vimPlugins.coc-explorer
    # Plugin for adding `prettier` support
    unstable.vimPlugins.coc-prettier
    # A fast finder system for neovim
    # https://github.com/camspiers/snap/
    unstable.vimPlugins.snap
    # Clean & Elegant Color Scheme inspired by Atom One and Material
    unstable.vimPlugins.edge
    # Delicious diagnostic debugging in Neovim
    unstable.vimPlugins.wtf-nvim

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
  ];
}
