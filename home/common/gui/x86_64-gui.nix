{ lib, config, system-details, pkgs, ... }:
let
  isx86_64 = (builtins.match "x86_64-linux" system-details.current-system != null);
in
{
  config = lib.mkIf (config.gui.enable && isx86_64) {
    home.packages = with pkgs; [
      # Rust based teamviewer
      rustdesk-flutter

      # Music
      tidal-hifi
    ] ++ (
    if
      # If the host is a kiosk, don't install chat apps.
      builtins.match "kiosk" system-details.host-type != null
    then
      [ ]
    else
      [
        # Chat apps
        discord
        element-desktop
        telegram-desktop
      ]
    );
  };
}
