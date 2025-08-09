{ pkgs, ... }:
{
  # modules/gui/tui
  # Packages that should be available on personal workstations, but not on servers.
  environment.systemPackages = with pkgs; [
    # GitHub tool for managing PRs and issues
    # https://github.com/dlvhdr/gh-dash
    gh-dash

    # bluetui - TUI for managing bluetooth on Linux
    # https://github.com/pythops/bluetui
    bluetui

    # Lazycli - A tool to static turn CLI commands into TUIs
    # https://github.com/jesseduffield/lazycli
    lazycli
  ];
}
