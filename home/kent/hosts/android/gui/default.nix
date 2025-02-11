{ system-details, lib, pkgs, ... }:
{
  # home/kent/hosts/android/gui
  imports = [
    ./rofi.nix
    ./wayland
  ];

  config = lib.mkIf (builtins.match "x11" system-details.display-type != null) {
    home.packages = with pkgs; [
      # DarkTable - Virtual lighttable and darkroom for photographers
      # https://github.com/darktable-org/darktable
      darktable

      # dconf - Gnome system config, wanted by darktable
      dconf
    ];

    android.gui.wayland.enable = true;
    xsession.numlock.enable = true;

    programs.alacritty.settings.font.size = 18;

    gui = {
      wm.i3.enable = true;
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
  };
}
