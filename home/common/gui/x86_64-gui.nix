{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust based teamviewer
    rustdesk-flutter

    # Chat apps
    discord
    element-desktop
    telegram-desktop

    # Music
    tidal-hifi
  ];
}
