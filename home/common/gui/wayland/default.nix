{ lib, pkgs, system-details, ... }:
let
  wayland = (builtins.match "wayland" system-details.display-type != null);
in
{
  imports = [
    ./wm
  ];

  config = lib.mkIf wayland {
    home.packages = with pkgs; [
      # Wayland tools
      wev
      wlprop
      wlr-randr

      # Possibly needed by hyprland?
      # Nvidia compatibility things
      #egl-wayland
    ];
  };
}
