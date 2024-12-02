{ pkgs, ... }:
{
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

    # pcmanfm - gui file manager
    pcmanfm

    # Mesa - OpenGL drivers
    unstable.mesa
  ];
}
