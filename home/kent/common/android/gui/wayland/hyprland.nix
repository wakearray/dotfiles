{ lib, config, pkgs, ... }:
let
  cfg = config.android.gui.wayland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Minimal x11 window manager to launch cage in
      openbox

      # Wayland kiosk that runs a single Wayland application
      cage

      # Wayland tiling window manager
      hyprland
    ];
    home.file.".local/bin/launch_hyperland" = {
      enable = true;
      force = true;
      executable = true;
      text = /*bash*/ ''
#!/usr/bin/env bash
export DISPLAY=:0
export XDG_RUNTIME_DIR="/tmp"
${pkgs.openbox}/bin/openbox &
${pkgs.cage} ${pkgs.hyprland}/bin/hyprland &
      '';
    };
  };
}
