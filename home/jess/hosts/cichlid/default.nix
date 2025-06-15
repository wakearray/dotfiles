{ ... }:
{
  # home/jess/cichlid
  imports = [
    ./starship.nix
    ./gnome.nix
  ];

  gui = {
    themes.catppuccin.enable = true;
  };
}
