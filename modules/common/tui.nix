{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Terminal UI for Systemd Logs and Status
    # https://crates.io/crates/systemctl-tui
    systemctl-tui

    # hyfetch - neofetch with pride flags
    # https://github.com/hykilpikonna/HyFetch
    hyfetch

    # Lazycli - A tool to static turn CLI commands into TUIs
    # https://github.com/jesseduffield/lazycli
    lazycli

    # GitUI provides you with the comfort of a git GUI
    # right in your terminal
    # https://github.com/extrawurst/gitui
    gitui

    # bluetui - TUI for managing bluetooth on Linux
    # https://github.com/pythops/bluetui
    bluetui
  ];
}
