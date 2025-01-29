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

sleep_time=0.07

move_windows() {
  # Switch all windows from from_monitor to to_secondary monitor

  from_monitor=$1
  to_monitor=$2

  ${hyprctl} dispatch focusmonitor "$to_monitor"
  sleep $sleep_time
  # move hyprland to a temporary workspace that doesn't have windows on it
  # to prevent issues with binds.workspace_back_and_forth
  ${hyprctl} dispatch split:workspace 400
  sleep $sleep_time
  ${hyprctl} dispatch focusmonitor "$from_monitor"
  sleep $sleep_time
  ${hyprctl} dispatch split:workspace 400
  sleep $sleep_time

  for workspace in 1 2 3 4 5 6 7 8 9
  do
    echo "Workspace: $workspace"
    ${hyprctl} dispatch focusmonitor "$to_monitor"
    sleep $sleep_time
    ${hyprctl} dispatch split:workspace "$workspace"
    sleep $sleep_time
    ${hyprctl} dispatch focusmonitor "$from_monitor"
    sleep $sleep_timeOr
    ${hyprctl} dispatch split:workspace "$workspace"
    sleep $sleep_time
    ${hyprctl} dispatch split:swapactiveworkspaces "$from_monitor" "$to_monitor"
    sleep $sleep_time
  done

  ${hyprctl} dispatch focusmonitor "$to_monitor"
  sleep $sleep_time
  ${hyprctl} dispatch split:workspace 1
  sleep $sleep_time
}

handle() {
  echo "$1"
  case $1 in
    "monitoraddedv2>>"*)
        monitor="''${1#"monitoraddedv2>>"}"
        monitor_num="''${1%",DP"*}"
        workspaces_offset=$((9 * monitor_num))
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Monitor $monitor connected, moving workspaces..."
        if [ $monitor_num == 1 ]; then
          move_windows 0 1
        fi
        ${ewwCommand} open bar --id "mon_$monitor_num" --screen $monitor_num --arg width="100%" --arg offset="$workspaces_offset"
      ;;
    monitorremoved\>\>*)
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "monitor ''${1#"monitorremoved>>"} disconnected, moving workspaces..."
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
