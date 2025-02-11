{ lib, config, pkgs, ... }:
let
  cfg = config.android.gui.wayland;
in
{
  imports = [
    ./hyprland.nix
  ];
  options.android.gui.wayland = with lib; {
    enable = mkEnableOption "Enable hyprland on Android in Termux using Termux:x11 and cage";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Minimal x11 window manager to launch cage in
      openbox

      # Wayland kiosk that runs a single Wayland application
      cage

      # A basic Wayland compositor example
      weston
    ];
  };
}
