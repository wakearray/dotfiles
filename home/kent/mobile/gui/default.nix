{ pkgs, ... }:
{
  imports = [
    ./i3.nix
    ../../alacritty.nix
  ];

  home.packages = with pkgs; [
    # Browser
    firefox-esr

    # Music
    tidal-hifi

    # DarkTable - Virtual lighttable and darkroom for photographers
    # https://github.com/darktable-org/darktable
    darktable

    # Localsend - An open source cross-platform alternative to AirDrop
    # https://github.com/localsend/localsend
    localsend

    # The suckless tiling window manager
    #dwm

    # Window Manager Required Stuff
    xorg.libX11
    xorg.xinit
    xorg.xorgserver
    xorg.xauth

    # Mesa - OpenGL drivers
    mesa
  ];
}
