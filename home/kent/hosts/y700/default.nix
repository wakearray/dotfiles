{ ... }:
{
  # home/kent/hosts/y700

  imports = [
    ./starship.nix
  ];

  config = {
    gui = {
      wm.i3.enable = true;
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

    android.gui.wayland.enable = true;
  };
}
