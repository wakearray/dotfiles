{ system-details, lib, pkgs, ... }:
{
  imports = [
    ./rofi.nix
  ];

  config = lib.mkIf (builtins.match "x11" system-details.display-type != null) {
    home.packages = with pkgs; [
      # DarkTable - Virtual lighttable and darkroom for photographers
      # https://github.com/darktable-org/darktable
      darktable

      # dconf - Gnome system config, wanted by darktable
      dconf
    ];

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
      };
      themes.gruvbox.enable = true;
    };
  };
}
