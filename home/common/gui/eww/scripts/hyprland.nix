{ lib, pkgs, config, ... }:
let
  eww = config.gui.eww;
  hyprland = config.home.wm.hyprland;
  ewwCommand = "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in
{
  config = lib.mkIf (eww.enable && hyprland.enable) {
    home = {
      file."/.config/eww/scripts/hyprland.sh" = {
        enable = true;
        force = true;
        executable = true;
        text = /*sh*/ ''
#!/bin/bash

handle() {
  case $1 in
    "monitoraddedv2>>1,DP-2,Stargate Technology F156P1 0x00001111")
        #TODO: disable monitor eDP-1 and make DP-2 into <primary>
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Stargate monitor connected, moving workspaces..."
        for i in {1..9}
        do
          ${hyprctl} split:workspace $i
          ${hyprctl} split:swapactiveworkspaces 0 1
        done
        ${hyprctl} keyword monitor "desc:Japan Display Inc. GPD1001H 0x00000001, disable"
      ;;
    monitoradded*)
        ${hyprctl} reload
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Monitor has been added: $1"
      ;;
    monitorremoved*)
        # Make sure eDP-1 is enabled.
        ${hyprctl} keyword monitor "desc:Japan Display Inc. GPD1001H 0x00000001, 2560x1600@60.01Hz, 0x0, 1.666667"
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "$1"
        # Use a for loop to move workspaces from previous workspace
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Stargate monitor disconnected, moving workspaces..."
        for i in {1..9}
        do
          ${hyprctl} split:workspace $i
          ${hyprctl} split:swapactiveworkspaces 1 0
        done
        # Grab any missed windows
        ${hyprctl} dispatch split:grabroguewindows
      ;;
    workspace\>\>*)
        ${ewwCommand} update active_workspace="''${1#"workspace>>"}"
      ;;
#   focusedmon*)
#     ;;
  esac
}

${pkgs.socat}/bin/socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done
      '';
      };
    };
  };
}
