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
#!/bin/sh

sleep_time=0.05

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
    sleep $sleep_time
    ${hyprctl} dispatch split:workspace "$workspace"
    sleep $sleep_time
    ${hyprctl} dispatch split:swapactiveworkspaces "$from_monitor" "$to_monitor"
    sleep $sleep_time
  done

  ${hyprctl} dispatch focusmonitor "$to_monitor"
  sleep $sleep_time
  ${hyprctl} dispatch split:workspace 1
  sleep $sleep_time

  ${ewwCommand} open bar --screen "$to_monitor"
}

handle() {
  echo "$1"
  case $1 in
    "monitoraddedv2>>1,DP-2,Stargate Technology F156P1 0x00001111")
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Stargate monitor connected, moving workspaces..."
        move_windows 0 1
        ${ewwCommand} open bar --id secondary --screen 1 --arg width="100%" --arg offset="9"
      ;;
    "monitoraddedv2>>1,DP-1,DZX Z1-9 0000000000000")
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "QQH monitor connected, moving workspaces..."
        move_windows 0 1
        ${ewwCommand} open bar --id secondary --screen 1 --arg width="100%" --arg offset="9"
      ;;
    "monitoraddedv2>>1"*)
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Monitor connected, moving workspaces..."
        move_windows 0 1
        ${ewwCommand} open bar --id secondary --screen 1 --arg width="100%" --arg offset="9"
      ;;
    "monitoraddedv2>>2"*)
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Monitor connected, moving workspaces..."
        ${ewwCommand} open bar --id tertiary --screen 2 --arg width="100%" --arg offset="18"
      ;;
    monitorremoved\>\>*)
        # Use a for loop to move workspaces from previous workspace
        ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "monitor ''${1#"monitorremoved>>"} disconnected, moving workspaces..."
        move_windows 1 0
        # Grab any missed windows
        ${hyprctl} dispatch split:grabroguewindows
        ${ewwCommand} open bar --id primary --screen 0 --arg width="118%" --arg offset="0"
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
