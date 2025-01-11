{ lib, config, system-details, ... }:
let
  cfg = config.gui.eww;
  battery = cfg.battery;
  colors = cfg.icons.colors;
in
{
  config = lib.mkIf (cfg.enable && battery.enable) {
    home = {
      file."/.config/eww/scripts/battery.sh" = {
        enable = true;
        force = true;
        executable = true;
        text = /*sh*/ ''
#!/bin/sh

BATT_COLOR=
COLOR_REGEX='s/\(style="fill:#\)......\(" \/>\)/\''$(BATT_COLOR)\2/'

while true
do
  BATT_CAPACITY=''$(cat /sys/class/power_supply/${battery.identifier}/capacity)
  BATT_STATUS=''$(cat /sys/class/power_supply/${battery.identifier}/status)
  eww update -c ${config.xdg.configHome}/eww/bar battery_status="''$(''$BATT_STATUS)"
  eww update -c ${config.xdg.configHome}/eww/bar battery_capacity="''$(''$BATT_CAPACITY)"
  if [[ $BATT_STATUS == "charging" ]]; then
    eww update -c ${config.xdg.configHome}/eww/bar battery_icon="../img/battery-charging.svg"
  else
    case  1:''${$BATT_CAPACITY:--} in
      (1:*[!0-9]*|1:0*[89]*)
        ! echo NAN
      ;;
      ($((BATT_CAPACITY<15))*)
        #echo "$BATT_CAPACITY >=0<=5"
        BATT_COLOR="${colors.battery-critical}"
        sed -i $COLOR_REGEX ../img/battery-empty.svg
        eww update -c ${config.xdg.configHome}/eww/bar battery_icon="../img/battery-empty.svg"
      ;;
      ($((BATT_CAPACITY<25))*)
        #echo "$BATT_CAPACITY >=6<=15"
        BATT_COLOR="${colors.battery-low}"
        sed -i $COLOR_REGEX ../img/battery-empty.svg
        eww update -c ${config.xdg.configHome}/eww/bar battery_icon="../img/battery-empty.svg"
      ;;
      ($((BATT_CAPACITY<99))*)
        #echo "$BATT_CAPACITY >=16<=100"
        BATT_COLOR="${colors.battery-discharging}"
        sed -i $COLOR_REGEX ../img/battery-empty.svg
        eww update -c ${config.xdg.configHome}/eww/bar battery_icon="../img/battery-empty.svg"
      ;;
      ($((BATT_CAPACITY<100))*)
        #echo "$BATT_CAPACITY >=100<=100"
        BATT_COLOR="${colors.battery-full}"
        sed -i $COLOR_REGEX ../img/battery-empty.svg
        eww update -c ${config.xdg.configHome}/eww/bar battery_icon="../img/battery-empty.svg"
      ;;
    esac
  fi
  sleep 10
done
      '';
      };
    };
  };
}
