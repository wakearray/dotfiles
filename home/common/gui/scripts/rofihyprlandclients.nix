{ config, lib, ... }:
let
  wayland = config.gui.wayland;
  rofi = config.gui.rofi;
  hyprland = config.home.wm.hyprland;
  clients = config.scripts.rofihyprlandclients;
in
{
  options.scripts.rofihyprlandclients = with lib; {
    enable = mkEnableOption "Enable a script that moves windows/workspaces from a given monitor to a different monitor.";
  };
  config = lib.mkIf (wayland.enable && (hyprland.enable && (rofi.enable && clients.enable))) {
    home.file.".local/bin/rofihyprlandclients" = {
      enable = true;
      force = true;
      executable = true;
      text = /*bash*/ ''
#!/usr/bin/env bash

CURRENT_WORKSPACE=$(hyprctl activeworkspace | rg "workspace ID " | sed "s/workspace ID \([0-9]\+\) .*/\1/")

if [ "$*" != "" ]
then
  coproc ( hyprctl dispatch movetoworkspace "$CURRENT_WORKSPACE",title:"$*" > /dev/null 2>&1 )
  exit 0
fi

# Generate list of windows
hyprctl clients | rg "title: " | sed -n "s/^.*title: //p"
      '';
    };
  };
}
