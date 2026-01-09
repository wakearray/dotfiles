{ pkgs, inputs, ... }:
{
  # modules/gui/tui
  # Packages that should be available on personal workstations, but not on servers.
  environment.systemPackages = with pkgs; [
    # GitHub cli tool
    # https://cli.github.com/
    gh

    # GitHub tool for managing PRs and issues
    # https://github.com/dlvhdr/gh-dash
    gh-dash

    # Lazycli - A tool to static turn CLI commands into TUIs
    # https://github.com/jesseduffield/lazycli
    lazycli
  ] ++ [ inputs.nix-inspect.packages.x86_64-linux.nix-inspect-release ];
}
