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
    ./fonts.nix
    ./gaming.nix
    ./lockers
    ./office.nix
    ./sound.nix
    ./syncthing.nix
    ./wm
    ./greeters
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

      firefox = {
        nativeMessagingHosts = {
          # Vim like keyboard control for Firefox
          tridactyl = true;
          # Allows Firefox to cast to Chromecast devices and apps
          # https://hensm.github.io/fx_cast/
          fxCast = true;
          # Allows you to force websites to play videos in mpv
          # https://github.com/ryze312/ff2mpv-rust
          ff2mpv = true;
        };
      };
    };

    # Command-line utility and library for controlling media players that implement MPRIS
    # https://github.com/altdesktop/playerctl
    services.playerctld.enable = true;

    environment = {
      systemPackages = with pkgs; [
        # Allows theming of QT6 applications like LibreOffice
        qt6ct

        # A windows task manager styled resource monitor
        mission-center

        # The XFCE terminal, installed as a backup.
        xfce.xfce4-terminal
      ];
      variables = {
        QT_QPA_PLATFORMTHEME="qt6ct";
      };
    };
  };
}
