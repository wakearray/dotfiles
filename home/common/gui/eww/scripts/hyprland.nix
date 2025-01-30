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
        text = /*bash*/ ''
#!/usr/bin/env bash

handle() {
  echo "$1"
  case $1 in
    "monitoraddedv2>>"*)
        monitor="''${1#"monitoraddedv2>>"}"
        monitor_num="''${1%",DP"*}"
        workspaces_offset=$((9 * monitor_num))
        ${hyprctl} notify 0 20000 "rgb(ff1ea3)" "Monitor $monitor connected"
        if [ $monitor_num == 1 ]; then
          sleep 1
          bash monitorswitch 0 1
        fi
        ${ewwCommand} open bar --id "mon_$monitor_num" --screen $monitor_num --arg width="100%" --arg offset="$workspaces_offset"
      ;;
    monitorremoved\>\>*)
        # ${hyprctl} notify 0 20000 "rgb(ff1ea3)" "monitor ''${1#"monitorremoved>>"} disconnected"
        # Grab any missed windows
        ${hyprctl} dispatch split:grabroguewindows
      ;;
    workspace\>\>*)
        ws_num="''${1#"workspace>>"}"
        ${ewwCommand} update active_workspace="''${ws_num}"
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
