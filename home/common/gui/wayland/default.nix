{ lib, config, pkgs, ... }:
let
  isWayland = config.home.systemDetails.display.wayland;
  isAndroid = config.home.systemDetails.isAndroid;
  wayland = config.gui.wayland;
in
{
  imports = [
    ./wm
    ./locker
  ];

  options.gui.wayland = with lib; {
    enable = mkOption {
      type = types.bool;
      default = (isWayland && (!isAndroid));
      description = "Defaults to true when systemDetails.display is wayland and systemDetails.hostType is not android.";
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
