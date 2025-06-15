{ config, lib, ... }:
let
  gui = config.gui;
  eww = gui.eww;
  bar = eww.bar;
  colors = bar.colors;
in
{
  imports = [
    ./eww.scss.nix
    ./eww.yuck.nix
  ];

  options.gui.eww.bar = with lib; {
    enable = mkEnableOption "Enable a generic bar config for eww.";

    colors = {
      text = mkOption {
        type = types.str;
        default = "#DDC7A1";
        description = "Which color to use for text and icons, bar text, tooltip text, and icon colors can be assigned separately if preferred.";
      };

      bar-fg = mkOption {
        type = types.str;
        default = colors.text;
        description = "Which color to use for the bar's text.";
      };

      bar-bg = mkOption {
        type = types.str;
        default = "#32302F";
        description = "Which color to use for the bar's background.";
      };

      tooltip-fg = mkOption {
        type = types.str;
        default = colors.text;
        description = "Which color to use for tooltip text.";
      };

      tooltip-bg = mkOption {
        type = types.str;
        default = colors.bar-bg;
        description = "Which color to use for tooltip background.";
      };

      metric-fg = mkOption {
        type = types.str;
        default = "#E78A4E";
        description = "Which color to use for the highlight color on the scale for things like volume, memory, and battery.";
      };

      metric-bg = mkOption {
        type = types.str;
        default = "#45403D";
        description = "Which color to use for the background color on the scale for things like volume, memory, and battery.";
      };

      workspace-active = mkOption {
        type = types.str;
        default = "#E78A4E";
        description = "Which color to use for the circle representing the active workspace.";
      };

      workspace-inactive = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Which color to use for the circles representing the inactive workspaces.";
      };
    };
  };

  config = lib.mkIf (gui.enable && (eww.enable && bar.enable)) {
    gui.eww = {
      icons.enable = true;
    };
  };
}
