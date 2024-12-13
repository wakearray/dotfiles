{ lib, ... }:
let
  # The expression colors includes all colors
  # found in the gruvbox material medium dark theme.
  #
  # Colors in eww can be defined in any method
  # supported by GTK.
  #
  # Names: "transparent", "red"
  # RGB: "rgb(128,57,0)"
  # RGB with alpha: "rgba(10%,20%,30%,0.5)"
  # 8-bit Hex: "#ff00cc"
  # 16-bit Hex: "#ffff0000cccc"
  colors = {
    bg_dim           = "#1B1B1B";
    bg_0             = "#282828";
    bg_1             = "#32302F";
    bg_2             = "#45403D";
    bg_3             = "#5A524C";
    bg_statusline_1  = "#32302F";
    bg_statusline_2  = "#3A3735";
    bg_statusline_3  = "#504945";
    bg_diff_green    = "#34381B";
    bg_diff_red      = "#402120";
    bg_diff_blue     = "#0E363E";
    bg_visual_green  = "#3B4439";
    bg_visual_red    = "#4C3432";
    bg_visual_blue   = "#374141";
    bg_visual_yellow = "#4F422E";
    bg_current_word  = "#3C3836";
    fg_0             = "#D4BE98";
    fg_1             = "#DDC7A1";
    fg_red           = "#EA6962";
    fg_orange        = "#E78A4E";
    fg_yellow        = "#D8A657";
    fg_green         = "#A9B665";
    fg_aqua          = "#89B482";
    fg_blue          = "#7DAEA3";
    fg_purple        = "#D3869B";
    fg_grey_0        = "#7C6F64";
    fg_grey_1        = "#928374";
    fg_grey_2        = "#A89984";
  };
in
{
  options.gui.themes.gruvbox = with lib; {
    enable = mkEnableOption "Enable the Gruvbox theme.";
  };
  config = {
    gui.eww = {
      enable = true;
      bar = {
        enable = true;
        colors = {
          fg-1 = colors.fg_0;
          fg-2 = colors.fg_1;
          bg-1 = colors.bg_0;
          bg-2 = colors.bg_1;
          accent-1 = colors.fg_orange;
          accent-2 = colors.fg_yellow;
        };
      };
    };
  };
}
