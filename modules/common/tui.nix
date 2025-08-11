{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Terminal UI for Systemd Logs and Status
    # https://crates.io/crates/systemctl-tui
    systemctl-tui

    # hyfetch - neofetch with pride flags
    # https://github.com/hykilpikonna/HyFetch
    hyfetch

    # GitHub cli tool
    # https://cli.github.com/
    gh

    # GitUI provides you with the comfort of a git GUI
    # right in your terminal
    # https://github.com/extrawurst/gitui
    gitui

    # gum - A tool for glamorous shell scripts
    # https://github.com/charmbracelet/gum
    gum

    # Interactively browse dependency graphs of Nix derivations.
    # https://hackage.haskell.org/package/nix-tree
    nix-tree
  ];
}
