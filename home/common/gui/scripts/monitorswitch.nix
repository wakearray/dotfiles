{ config, lib, ... }:
let
  wayland = config.gui.wayland;
  hyprland = config.home.wm.hyprland;
  monitorSwitch = config.scripts.monitorSwitch;
in
{
  options.scripts.monitorSwitch = with lib; {
    enable = mkEnableOption "Enable a script that moves windows/workspaces from a given monitor to a different monitor.";
  };
  config = lib.mkIf (wayland.enable && (hyprland.enable && monitorSwitch.enable)) {
    home.file.".local/bin/monitorswitch" = {
      enable = true;
      force = true;
      executable = true;
      text = /*bash*/ ''
#!/usr/bin/env bash

sleep_time=0.05

# Switch all windows from from_monitor to to_secondary monitor

from_monitor=$1
to_monitor=$2

hyprctl dispatch focusmonitor "$to_monitor" > /dev/null 2>&1
sleep $sleep_time
# move hyprland to a temporary workspace that doesn't have windows on it
# to prevent issues with binds.workspace_back_and_forth
hyprctl dispatch split:workspace 400 > /dev/null 2>&1
sleep $sleep_time
hyprctl dispatch focusmonitor "$from_monitor" > /dev/null 2>&1
sleep $sleep_time
hyprctl dispatch split:workspace 400 > /dev/null 2>&1
sleep $sleep_time

for workspace in 1 2 3 4 5 6 7 8 9
do
  echo "Workspace: $workspace"
  hyprctl dispatch focusmonitor "$to_monitor" > /dev/null 2>&1
  sleep $sleep_time
  hyprctl dispatch split:workspace "$workspace" > /dev/null 2>&1
  sleep $sleep_time
  hyprctl dispatch focusmonitor "$from_monitor" > /dev/null 2>&1
  sleep $sleep_time
  hyprctl dispatch split:workspace "$workspace" > /dev/null 2>&1
  sleep $sleep_time
  hyprctl dispatch split:swapactiveworkspaces "$from_monitor" "$to_monitor" > /dev/null 2>&1
  sleep $sleep_time
done

hyprctl dispatch focusmonitor "$to_monitor" > /dev/null 2>&1
sleep $sleep_time
hyprctl dispatch split:workspace 1 > /dev/null 2>&1
sleep $sleep_time

      '';
    };
  };
}
