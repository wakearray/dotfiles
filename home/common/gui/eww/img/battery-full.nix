{ config, lib, ... }:
let
  cfg = config.gui.eww;
  colors = cfg.icons.colors;
  battery = cfg.battery;
in
{
  config = lib.mkIf (cfg.enable && battery.enable) {
    home.file."/.config/eww/img/battery-full.svg" = {
      enable = true;
      force = true;
      text = /*svg*/''
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!--!Font Awesome Free 6.7.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.-->
<svg
   viewBox="0 0 576 512"
   version="1.1"
   id="svg1"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <path
     d="M464 160c8.8 0 16 7.2 16 16l0 160c0 8.8-7.2 16-16 16L80 352c-8.8 0-16-7.2-16-16l0-160c0-8.8 7.2-16 16-16l384 0zM80 96C35.8 96 0 131.8 0 176L0 336c0 44.2 35.8 80 80 80l384 0c44.2 0 80-35.8 80-80l0-16c17.7 0 32-14.3 32-32l0-64c0-17.7-14.3-32-32-32l0-16c0-44.2-35.8-80-80-80L80 96zm368 96L96 192l0 128 352 0 0-128z"
     id="path1"
     style="fill:${colors.battery-discharging}" />
</svg>
      '';
    };
  };
}