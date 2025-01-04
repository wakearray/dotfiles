{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Wayland tools
    wev
    wlprop

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
