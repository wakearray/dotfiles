{ lib, config, pkgs, system-details, ... }:
let
  isWayland = (builtins.match "wayland" system-details.display-type != null);
  isAndroid = (builtins.match "android" system-details.host-type != null);
  wayland = config.gui.wayland;
in
{
  imports = [
    ./wm
  ];

  options.gui.wayland = with lib; {
    enable = mkOption {
      type = types.bool;
      default = (isWayland && (!isAndroid));
      description = "Defaults to true when system-details.display-type is wayland and system-details.host-type is not android.";
    };
  };
  config = lib.mkIf wayland.enable {
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
