{ pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./polybar.nix
  ];
  # home/common/android/gui
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
}
