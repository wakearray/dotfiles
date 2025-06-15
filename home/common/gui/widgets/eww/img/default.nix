{ lib, ... }:
{
  imports = [
    ./memory.nix
    ./volume-high.nix
    ./volume-low.nix
    ./volume-mute.nix
    ./volume-off.nix
  ];

  options.gui.eww.icons = with lib; {
    enable = mkEnableOption "Enable icons in eww.";

    colors = {
      # Battery Icon Colors
      battery-full = mkOption {
        type = types.str;
        default = "#A9B665";
        description = "Color for the battery icon when battery is fully charged.";
      };
      battery-charging = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for battery icon when battery is charging.";
      };
      battery-discharging = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for battery icon when battery is discharging.";
      };
      battery-low = mkOption {
        type = types.str;
        default = "#E78A4E";
        description = "Color for battery icon when battery is low.";
      };
      battery-critical = mkOption {
        type = types.str;
        default = "#EA6962";
        description = "Color for battery icon when battery is critically low.";
      };

      # Volume Icon Colors
      volume-mute = mkOption {
        type = types.str;
        default = "#A89984";
        description = "Color for volume icon when volume is muted.";
      };
      volume-low = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for volume icon when volume is low.";
      };
      volume-medium = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for volume icon when volume is medium.";
      };
      volume-high = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for volume icon when volume is high.";
      };
      volume-critical-high = mkOption {
        type = types.str;
        default = "#EA6962";
        description = "Color for volume icon when volume is critically high (over 100%).";
      };

      # Colors for Memory Icon
      memory-useage-low = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for memory icon when memory usage is low.";
      };
      memory-useage-medium = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for memory icon when memory usage is medium.";
      };
      memory-useage-high = mkOption {
        type = types.str;
        default = "#E78A4E";
        description = "Color for memory icon when memory usage is high.";
      };
      memory-useage-critical-high = mkOption {
        type = types.str;
        default = "#EA6962";
        description = "Color for memory icon when memory usage is critically high.";
      };

      # Colors for Brightness Icon
      brightness-low = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for brightness icon when screen brightness is set low.";
      };
      brightness-medium = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "Color for brightness icon when screen brightness is set medium.";
      };
      brightness-high = mkOption {
        type = types.str;
        default = "#E78A4E";
        description = "Color for brightness icon when screen brightness is set high.";
      };
    };
  };
}
