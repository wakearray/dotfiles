{ lib, config, ... }:
let
  cfg = config.gui.eww;
in
{
  options.gui.eww.scripts.getvol = {
    enable = lib.mkEnableOption "Enable the ability for eww to see the current volume.";
  };
  config = lib.mkIf (cfg.enable && cfg.scripts.getvol.enable) {
    home.file."/.config/eww/scripts/getvol" = {
      enable = true;
      executable = true;
      force = true;
      text = ''
#!/bin/sh

if command -v pamixer &>/dev/null; then
    if [ true == $(pamixer --get-mute) ]; then
        echo 0
        exit
    else
        pamixer --get-volume
    fi
else
    amixer -D pulse sget Master | awk -F '[^0-9]+' '/Left:/{print $3}'
fi
      '';
    };
  };
}
