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
      text = /*svg*/ ''
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!--!Font Awesome Free 6.7.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.-->
<svg
   viewBox="0 0 576 512"
   version="1.1"
   id="svg1"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <path
     d="M80 160c-8.8 0-16 7.2-16 16l0 160c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-160c0-8.8-7.2-16-16-16L80 160zM0 176c0-44.2 35.8-80 80-80l384 0c44.2 0 80 35.8 80 80l0 16c17.7 0 32 14.3 32 32l0 64c0 17.7-14.3 32-32 32l0 16c0 44.2-35.8 80-80 80L80 416c-44.2 0-80-35.8-80-80L0 176z"
     id="path1"
     style="fill:${colors.battery-charging}" /><path
     d="m 400.18845,332.44397 c 8.13458,3.50321 17.63481,0.89064 22.85993,-6.2939 5.22513,-7.18455 4.75012,-16.98167 -1.06877,-23.6912 L 288.97639,150.45519 c -5.22513,-5.93764 -13.5972,-8.07519 -20.95988,-5.2845 -7.36268,2.79069 -12.3503,9.91586 -12.3503,17.81293 v 66.20473 L 149.14488,183.52787 c -8.13457,-3.50321 -17.6348,-0.89065 -22.85993,6.2939 -5.22512,7.18455 -4.75011,16.98166 1.06878,23.6912 l 133.00322,152.00367 c 5.22513,5.93765 13.5972,8.0752 20.95988,5.2845 7.36268,-2.79069 12.29092,-9.85648 12.29092,-17.81293 v -66.20472 z"
     id="path1-5"
     style="fill:${colors.battery-charging}" />
</svg>
      '';
    };
  };
}
