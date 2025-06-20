{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./starship.nix
  ];

  config = {
    gui = {
      cliphist.enable = true;
      themes.gruvbox = {
        enable = true;
        cursorSize = 24;
      };
      alacritty.enable = true;

      eww = {
        enable = true;
        bar.enable = true;
      };

      rofi = {
        enable = true;
        plugins = with pkgs; [
          # Bluetooth configuration in rofi
          # https://github.com/nickclyde/rofi-bluetooth
          rofi-bluetooth
        ];
        modi = "drun";
      };
    };
  };
}
