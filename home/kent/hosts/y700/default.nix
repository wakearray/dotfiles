{ pkgs, ... }:
{
  # home/kent/hosts/y700

  imports = [
    ./starship.nix
    #./hyprland.nix
  ];

  config = {
    gui = {
      wm.i3 = {
        enable = true;
        i3wsr.enable = false;
      };
      #polybar.enable = true;
      eww = {
        enable = true;
        battery = {
          enable = true;
          identifier = "battery";
        };
        bar = {
          enable = true;
        };
      };
      themes.gruvbox.enable = true;
    };

    programs.alacritty.settings.font.size = 18;
  };
}
