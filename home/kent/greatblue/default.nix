{ pkgs, ... }:
{
  imports = [
    ./starship.nix
    ./hyprland.nix
    ./hyprlock.nix
    ../../themes/gruvbox
  ];
  config = {
    programs = {
      # imv - a command line image viewer intended for use with tiling window managers
      # https://sr.ht/~exec64/imv/
      imv.enable = true;
    };

    gui = {
      cliphist.enable = true;
      themes.gruvbox.enable = true;
    };

    home.packages = with pkgs; [
      wev
      wlprop
    ];
  };
}
