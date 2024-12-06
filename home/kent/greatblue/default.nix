{ ... }:
{
  imports = [
    ./starship.nix
    ./hyprland.nix
  ];
  programs = {
    # imv - a command line image viewer intended for use with tiling window managers
    # https://sr.ht/~exec64/imv/
    imv.enable = true;
  };
}
