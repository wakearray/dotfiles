{ lib, config, pkgs, ... }:
let
  agui = config.android.gui;
  wayland = agui.wayland;
in
{
  imports = [
    ./hyprland.nix
  ];
  options.android.gui.wayland = with lib; {
    enable = mkEnableOption "Enable hyprland on Android in Termux using Termux:x11 and cage";
  };

  config = lib.mkIf (agui.enable && wayland.enable) {
    home.packages = with pkgs; [
      # A basic Wayland compositor example
      weston

      # Verification of GPU accel
      glmark2
      mesa-demos
      vulkan-tools

      # A wayland compositor known to work in cage oin termux using proot
      phoc
      phosh
      phosh-mobile-settings
    ];
  };
}
