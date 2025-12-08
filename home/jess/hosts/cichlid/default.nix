{ pkgs, ... }:
{
  # home/jess/cichlid
  imports = [
    ./starship.nix
    ./gnome.nix
  ];

  gui = {
    themes.catppuccin.enable = true;
  };

  home.packages = with pkgs; [
    # aseprite - Animated sprite editor & pixel art tool
    # https://www.aseprite.org/
    aseprite
  ];
}
