{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  eww = gui.eww;
  battery = eww.battery;
  ewwCommand = "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in
{
  config = lib.mkIf (gui.enable && (eww.enable && battery.enable)) {
    home = {
      file."/.config/eww/scripts/battery.sh" = {
        enable = true;
        force = true;
        executable = true;
        text = /*sh*/ ''
#!/usr/bin/env bash

function change_icon () {
  ICON="$1"
  CLASS="$2"
  echo "Icon: $ICON | Class: $CLASS"
  ${ewwCommand} update battery_icon="$ICON"
  ${ewwCommand} update battery_class="$CLASS"
}

EWW_OLD_BATT_CAPACITY=null
EWW_OLD_BATT_STATUS=null

while true
do
  BATT_CAPACITY=$(cat /sys/class/power_supply/${battery.identifier}/capacity)
  BATT_STATUS=$(cat /sys/class/power_supply/${battery.identifier}/status)

  if [ "$BATT_CAPACITY" != "$EWW_OLD_BATT_CAPACITY" ] || [ "$BATT_STATUS" != "$EWW_OLD_BATT_STATUS" ]; then
    ${ewwCommand} update battery_status="$BATT_STATUS"
    ${ewwCommand} update battery_capacity="$BATT_CAPACITY"
    EWW_OLD_BATT_CAPACITY=$BATT_CAPACITY
    EWW_OLD_BATT_STATUS=$BATT_STATUS
    if [ "$BATT_STATUS" == "Charging" ]; then
      case  1:''${BATT_CAPACITY:--} in
        (1:*[!0-9]*|1:0*[89]*)
          ! echo NAN
        ;;
        ($((BATT_CAPACITY<10))*)
          #echo "$BATT_CAPACITY >=0<=10"
          change_icon "󰂎󱐋" "battery-charging"
        ;;
        ($((BATT_CAPACITY<20))*)
          #echo "$BATT_CAPACITY >=11<=20"
          change_icon "󰁺󱐋" "battery-charging"
        ;;
        ($((BATT_CAPACITY<30))*)
          #echo "$BATT_CAPACITY >=21<=30"
          change_icon "󰁻󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<40))*)
          #echo "$BATT_CAPACITY >=31<=40"
          change_icon "󰁼󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<50))*)
          #echo "$BATT_CAPACITY >=41<=50"
          change_icon "󰁽󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<60))*)
          #echo "$BATT_CAPACITY >=51<=60"
          change_icon "󰁾󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<70))*)
          #echo "$BATT_CAPACITY >=61<=70"
          change_icon "󰁿󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<80))*)
          #echo "$BATT_CAPACITY >=71<=80"
          change_icon "󰂀󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<90))*)
          #echo "$BATT_CAPACITY >=81<=90"
          change_icon "󰂁󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<98))*)
          #echo "$BATT_CAPACITY >=91<=98"
          change_icon "󰂂󱐋" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<101))*)
          #echo "$BATT_CAPACITY >=99<=101"
          change_icon "󰁹󱐋" "battery-discharging"
        ;;
      esac
    else
      case  1:''${BATT_CAPACITY:--} in
        (1:*[!0-9]*|1:0*[89]*)
          ! echo NAN
        ;;
        ($((BATT_CAPACITY<5))*)
          #echo "$BATT_CAPACITY >=0<=10"
          change_icon "󰂎!" "battery-critical"
          ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Beginning shutdown procedures!"
          # Save all files currently open in neovim
          ${pkgs.neovim}/bin/nvim --server /tmp/nvim --remote-send '<C-\><C-N>:wa<CR>'
          #sleep 1000
          #shutdown
        ;;
        ($((BATT_CAPACITY<10))*)
          #echo "$BATT_CAPACITY >=5<=10"
          change_icon "󰂎!" "battery-critical"
          ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Battery critical!"
        ;;
        ($((BATT_CAPACITY<20))*)
          #echo "$BATT_CAPACITY >=11<=20"
          change_icon "󰁺" "battery-low"
          ${hyprctl} notify 0 10000 "rgb(ff1ea3)" "Battery low!"
        ;;
        ($((BATT_CAPACITY<30))*)
          #echo "$BATT_CAPACITY >=21<=30"
          change_icon "󰁻" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<40))*)
          #echo "$BATT_CAPACITY >=31<=40"
          change_icon "󰁼" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<50))*)
          #echo "$BATT_CAPACITY >=41<=50"
          change_icon "󰁽" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<60))*)
          #echo "$BATT_CAPACITY >=51<=60"
          change_icon "󰁾" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<70))*)
          #echo "$BATT_CAPACITY >=61<=70"
          change_icon "󰁿" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<80))*)
          #echo "$BATT_CAPACITY >=71<=80"
          change_icon "󰂀" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<90))*)
          #echo "$BATT_CAPACITY >=81<=90"
          change_icon "󰂁" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<98))*)
          #echo "$BATT_CAPACITY >=91<=98"
          change_icon "󰂂" "battery-discharging"
        ;;
        ($((BATT_CAPACITY<101))*)
          #echo "$BATT_CAPACITY >=99<=101"
          change_icon "󰁹" "battery-discharging"
        ;;
      esac
    fi
  fi
  sleep 60
done
      '';
      };
    };
  };
}
