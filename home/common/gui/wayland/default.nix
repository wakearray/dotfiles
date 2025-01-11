{ lib, pkgs, system-details, ... }:
let
  wayland = (builtins.match "wayland" system-details.display-type != null);
in
{
  config = lib.mkIf wayland {
    home.packages = with pkgs; [
      # Wayland tools
      wev
      wlprop
    ];
  };
}
