{ lib, pkgs, system-details, ... }:
{
  # home/jess/common/gui
  # Programs and settings for all hosts using a GUI
  config = lib.mkIf (builtins.match "x11"     system-details.display-type != null ||
                     builtins.match "wayland" system-details.display-type != null) {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    home.packages = with pkgs; [
      pcmanfm
      file-roller
      # aseprite - Animated sprite editor & pixel art tool
      # https://www.aseprite.org/
      aseprite
    ];
  };
}
