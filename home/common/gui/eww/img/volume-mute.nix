{ config, lib, ... }:
let
  cfg = config.gui.eww;
  colors = cfg.icons.colors;
in
{
  config = lib.mkIf (cfg.enable && cfg.icons.enable) {
    home.file."/.config/eww/img/volume-mute.svg" = {
      enable = true;
      force = true;
      text = ''
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!--!Font Awesome Free 6.7.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.-->
<svg
   viewBox="0 0 576 512"
   version="1.1"
   id="svg1"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <path
     d="M301.1 34.8C312.6 40 320 51.4 320 64l0 384c0 12.6-7.4 24-18.9 29.2s-25 3.1-34.4-5.3L131.8 352 64 352c-35.3 0-64-28.7-64-64l0-64c0-35.3 28.7-64 64-64l67.8 0L266.7 40.1c9.4-8.4 22.9-10.4 34.4-5.3zM425 167l55 55 55-55c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9l-55 55 55 55c9.4 9.4 9.4 24.6 0 33.9s-24.6 9.4-33.9 0l-55-55-55 55c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l55-55-55-55c-9.4-9.4-9.4-24.6 0-33.9s24.6-9.4 33.9 0z"
     id="path1"
     style="fill:${colors.volume-mute}" />
</svg>
      '';
    };
  };
}