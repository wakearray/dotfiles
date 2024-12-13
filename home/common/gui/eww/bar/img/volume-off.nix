{ config, lib, ... }:
let
  cfg = config.gui.eww.bar;
  colors = cfg.colors;
in
{
  config = lib.mkIf config.gui.eww.bar.enable {
    home.file."/.config/eww/img/volume-off.svg" = {
      enable = true;
      force = true;
      text = ''
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   viewBox="0 0 320 512"
   version="1.1"
   id="svg1"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <path
     d="M320 64c0-12.6-7.4-24-18.9-29.2s-25-3.1-34.4 5.3L131.8 160 64 160c-35.3 0-64 28.7-64 64l0 64c0 35.3 28.7 64 64 64l67.8 0L266.7 471.9c9.4 8.4 22.9 10.4 34.4 5.3S320 460.6 320 448l0-384z"
     id="path1"
     style="fill:${colors.accent-2}" />
</svg>
      '';
    };
  };
}
