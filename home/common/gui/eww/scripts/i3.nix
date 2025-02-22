{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  eww = gui.eww;
  i3 = gui.wm.i3;
  ewwCommand = "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar";
  i3-msg = "${pkgs.i3}/bin/i3-msg";
in
{
  config = lib.mkIf (gui.enable && (eww.enable && i3.enable)) {
    home = {
      packages = with pkgs; [ jq ];
      file."/.config/eww/scripts/i3_listen_active_workspace.sh" = {
        enable = true;
        force = true;
        executable = true;
        text = /*sh*/ ''
#!/usr/bin/env bash

${i3-msg} -t subscribe -m '{"type":"workspace"}' |
while read -r _; do
    workspaces_info=$(${i3-msg} -t get_workspaces)
    active_workspace=$(echo "$workspaces_info" | jq -r '.[] | select(.visible == true) | .name')
    case $active_workspace in
      "1: 4a70")
        ${ewwCommand} update active_workspace="1"
        ;;
      "2: d772")
        ${ewwCommand} update active_workspace="2"
        ;;
      "3: 91b3")
        ${ewwCommand} update active_workspace="3"
        ;;
      "4: 4a1d")
        ${ewwCommand} update active_workspace="4"
        ;;
      "5: bfa0")
        ${ewwCommand} update active_workspace="5"
        ;;
      "6: 4fcd")
        ${ewwCommand} update active_workspace="6"
        ;;
      "7: 742e")
        ${ewwCommand} update active_workspace="7"
        ;;
      "8: f458")
        ${ewwCommand} update active_workspace="8"
        ;;
      "9: 3107")
        ${ewwCommand} update active_workspace="9"
        ;;
    esac
    # echo "$active_workspace"
done
      '';
      };
      file."/.config/eww/scripts/set_workspace.sh" = {
        enable = true;
        force = true;
        executable = true;
        text = /*sh*/ ''
#!/usr/bin/env bash

WS1="1: 4a70"
WS2="2: d772"
WS3="3: 91b3"
WS4="4: 4a1d"
WS5="5: bfa0"
WS6="6: 4fcd"
WS7="7: 742e"
WS8="8: f458"
WS9="9: 3107"

change_workspace() {
  ${i3-msg} workspace "$1"
  echo "${i3-msg} workspace $1"
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
