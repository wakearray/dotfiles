{ lib, config, ... }:
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

    # Cross platform Airdrop replacement
    programs.localsend.enable = true;

    # Command-line utility and library for controlling media players that implement MPRIS
    # https://github.com/altdesktop/playerctl
    services.playerctld.enable = true;
  };
}
