{ lib, config, pkgs, ... }:
let
  sd = config.modules.systemDetails.display;
  gui = config.gui;
in
{
  # modules/common/gui
  # Defaults for any GUI specific applications that I want on every GUI capable computer
  imports = [
    ./_1pass.nix
    ./bluetooth.nix
    ./fonts.nix
    ./gaming.nix
    ./greeters
    ./kiosk.nix
    ./lockers
    ./office.nix
    ./sound.nix
    ./syncthing.nix
    ./tui.nix
    ./wm
  ];

  options.gui = with lib; {
    enable = mkOption {
      type = types.bool;
      default = (sd.wayland || sd.x11);
      description = "Enable sound and nerdfonts on non headless hosts.";
    };
  };

  config = lib.mkIf gui.enable {
    # Policy Kit, enables elevating the priviledges of GUI applications
    security.polkit.enable = true;

    programs = {
      # Cross platform Airdrop replacement
      localsend.enable = true;
    };

    services = {
      # Command-line utility and library for controlling media players that implement MPRIS
      # https://github.com/altdesktop/playerctl
      playerctld.enable = true;

      # DBus service that allows applications to query and manipulate storage devices
      # Additional settings: https://search.nixos.org/options?channel=unstable&show=services.udisks2.settings
      udisks2.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [
        # Allows theming of QT6 applications like LibreOffice
        qt6Packages.qt6ct

        # A windows task manager styled resource monitor
        mission-center

        # The XFCE terminal, installed as a backup.
        xfce.xfce4-terminal

        # A simple calculator designed for elementary OS
        pantheon.elementary-calculator
      ];

      variables = {
        QT_QPA_PLATFORMTHEME="qt6ct";
      };
    };
  };
}
