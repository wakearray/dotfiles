{ lib,
  config,
  ... }:
let
  cfg = config.gui;
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
    ./wm
    ./greeters
  ];
  options.gui = with lib; {
    enable = mkEnableOption "Enable sound and nerdfonts on non headless hosts.";
  };

  config = lib.mkIf cfg.enable {
    # Policy Kit, enables elevating the priviledges of GUI applications
    security.polkit.enable = true;

    # Cross platform Airdrop replacement
    programs.localsend.enable = true;
  };
}
