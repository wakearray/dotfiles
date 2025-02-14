{ lib, config, system-details, pkgs, ... }:
let
  isx11 = (builtins.match "x11" system-details.display-type != null);
  x11 = config.gui.x11;
in
{
  # home/common/android/gui
  imports = [
    ./i3
    ./polybar.nix
  ];

  options.gui.x11 = with lib; {
    enable = mkOption {
      type = types.bool;
      default = isx11;
      description = "Default is `true` if `system-details.display-type = \"x11\"`";
    };
  };
  config = lib.mkIf x11.enable {
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
