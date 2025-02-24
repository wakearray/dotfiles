{ lib, pkgs, config, ... }:
let
  gui = config.gui;
  eww = gui.eww;
  hyprland = config.home.wm.hyprland;
  ewwCommand = "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in
{
  config = lib.mkIf (gui.enable && (eww.enable && hyprland.enable)) {
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
        monitor_num="''${1%",DP-"*}"
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
      file."/.config/eww/scripts/set_workspace.sh" = {
        enable = true;
        force = true;
        executable = true;
        text = /*bash*/ ''
#!/usr/bin/env bash

WS1="1"
WS2="2"
WS3="3"
WS4="4"
WS5="5"
WS6="6"
WS7="7"
WS8="8"
WS9="9"

change_workspace() {
  ${hyprctl} dispatch split:workspace "$1"
}

case $1 in
  "1")
    change_workspace "$WS1"
  ;;
  "2")
    change_workspace "$WS2"
  ;;
  "3")
    change_workspace "$WS3"
  ;;
  "4")
    change_workspace "$WS4"
  ;;
  "5")
    change_workspace "$WS5"
  ;;
  "6")
    change_workspace "$WS6"
  ;;
  "7")
    change_workspace "$WS7"
  ;;
  "8")
    change_workspace "$WS8"
  ;;
  "9")
    change_workspace "$WS9"
  ;;
esac
        '';
      };
    };
  };
}
