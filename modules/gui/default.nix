{ lib,
  ... }:
{
  # Defaults for any GUI specific applications that I want on every GUI capable computer
  imports = [
    ./_1pass.nix
    ./fonts.nix
    ./gaming.nix
    ./sound.nix
    ./wm
  ];
  options.gui = {
    enable = lib.mkEnableOption "Enable sound and nerdfonts on non headless hosts.";
  };
}
