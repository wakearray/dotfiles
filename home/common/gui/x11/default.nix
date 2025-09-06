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
      xorg.libX11
      xorg.xinit
      xorg.xorgserver
      xorg.xauth
      xorg.xrdb
      xorg.xwininfo
      xorg.xprop
      xorg.xev

      # pcmanfm - gui file manager
      pcmanfm

      # Mesa - OpenGL drivers
      mesa
    ];
  };
}
