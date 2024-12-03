{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    # Rust based teamviewer
    rustdesk-flutter
  ];
}
