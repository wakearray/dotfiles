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

    # Localsend - An open source cross-platform alternative to AirDrop
    # https://github.com/localsend/localsend
    localsend

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

  programs = {
    zsh = {
      shellAliases = {
        nglu = "nix run --impure github:nix-community/nixGL -- ";
        ngl = "nix run --override-input nixpkgs nixpkgs/nixos-24.05 --impure github:nix-community/nixGL -- ";
      };
    };
  };
}
