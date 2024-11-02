{ pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./firefox.nix
    ../../alacritty.nix
  ];

  home.packages = with pkgs; [
    # DarkTable - Virtual lighttable and darkroom for photographers
    # https://github.com/darktable-org/darktable
    darktable

    # dconf - Gnome system config, wanted by darktable
    dconf

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

    # Keepassxc - Offline password manager
    keepassxc

    # Mesa - OpenGL drivers
    unstable.mesa
  ];

  xsession.numlock.enable = true;

  programs = {
    alacritty = {
      settings = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [ "--login" "-c" "zellij" ];
        };
        font = {
          size = 18;
        };
      };
    };
  };
}
