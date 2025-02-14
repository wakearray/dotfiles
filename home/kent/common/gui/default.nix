{ lib, system-details, pkgs, ... }:
let
  wayland = (builtins.match "wayland" system-details.display-type != null);
  android = (builtins.match "android" system-details.host-type != null);
in
{
  # kent/common/gui
  # All settings and packages should be compatible with Android profiles
  imports = [
    ./gurk.nix
    #./todo.nix
    ../../../themes/gruvbox
  ];

  # maybe want this: GTK_THEME=Arc-Dark file-roller
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  gui = {
    rofi = lib.mkIf (wayland && (!android)) {
      enable = true;
      plugins = with pkgs; [
        # Bluetooth configuration in rofi
        # https://github.com/nickclyde/rofi-bluetooth
        rofi-bluetooth

        # Emoji picker for rofi - Built against rofi-wayland
        # https://github.com/Mange/rofi-emoji
        rofi-emoji-wayland
      ];
      modi = "drun,todo:todofi.sh,filebrowser,emoji";
    };
    firefox.enable = true;
  };

  home.packages = with pkgs; [
    pcmanfm
    file-roller
  ];
}
