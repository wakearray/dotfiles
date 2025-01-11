{ lib, config, ... }:
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
  cfg = config.gui.themes.gruvbox;
in
{
  options.gui.themes.gruvbox = with lib; {
    enable = mkEnableOption "Enable the Gruvbox theme.";
  };
  config = lib.mkIf cfg.enable {
    gui = {
      eww = {
        bar = {
          colors = {
            text = colors.fg_1;
            bar-fg = colors.fg_1;
            bar-bg = colors.bg_1;
            tooltip-fg = colors.fg_1;
            tooltip-bg = colors.bg_1;
            metric-fg = colors.fg_orange;
            metric-bg = colors.bg_2;
            workspace-active = colors.fg_orange;
            workspace-inactive = colors.fg_yellow;
          };
        };
        icons.colors = {
          battery-full = colors.fg_green;
          battery-charging = colors.fg_yellow;
          battery-discharging = colors.fg_yellow;
          battery-low = colors.fg_orange;
          battery-critical = colors.fg_red;
          volume-mute = colors.fg_grey_2;
          volume-low = colors.fg_yellow;
          volume-medium = colors.fg_yellow;
          volume-high = colors.fg_yellow;
          volume-critical-high = colors.fg_red;
          memory-useage-low = colors.fg_yellow;
          memory-useage-medium = colors.fg_yellow;
          memory-useage-high = colors.fg_orange;
          memory-useage-critical-high = colors.fg_red;
          brightness-low = colors.fg_yellow;
          brightness-medium = colors.fg_yellow;
          brightness-high = colors.fg_yellow;
        };
      };
    };
    home = {
      wm.hyprland = {
        colors = {
          general = {
            inactiveBorder      = (builtins.replaceStrings ["#"] ["0xff"] colors.bg_1 );
            activeBorder        = (builtins.replaceStrings ["#"] ["0xff"] colors.fg_orange );
            noGroupBorder       = (builtins.replaceStrings ["#"] ["0xff"] colors.bg_2 );
            noGroupAorderActive = (builtins.replaceStrings ["#"] ["0xff"] colors.fg_yellow );
          };
        };
      };
    };
  };
}
