{ lib, config, pkgs, ... }:
let
  cfg = config.gui.x11;
in
{
  # home/common/android/gui
  imports = [
    ./i3
    ./polybar.nix
  ];

  options.gui.x11 = with lib; {
    enable = mkEnableOption "Default is `true` if `systemDetails.display = \"x11\"`" // {
      default = config.home.systemDetails.display.x11; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # clipboard management
      xclip

      # Window Manager Required Stuff
      libx11
      xinit
      xorgserver
      xauth
      xrdb
      xwininfo
      xprop
      xev

      # Mesa - OpenGL drivers
      mesa
    ];
  };
}
