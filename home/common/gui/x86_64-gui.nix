{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  isx86_64 = config.home.systemDetails.architecture.isx86_64;
  isKiosk  = config.home.systemDetails.isKiosk;
in
{
  # This file is exclusively for common GUI packages that do not have aarch64 support
  config = lib.mkIf (gui.enable && isx86_64) {
    home.packages = with pkgs; [
      # Rust based teamviewer
      rustdesk-flutter

      # Music
      tidal-hifi
    ] ++ (
    if
      # If the host is a kiosk, don't install chat apps.
      isKiosk
    then
      [ ]
    else
      [
        # Chat apps
        discord
        element-desktop
        telegram-desktop
        signal-desktop
      ]
    );
  };
}
