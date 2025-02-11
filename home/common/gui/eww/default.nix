{ lib, config, pkgs, ... }:
let
  cfg = config.gui.eww;
in
{
  # home/common/gui/eww/
  imports = [
    ./bar
    ./scripts
    ./img
  ];

  options.gui.eww = with lib; {
    enable = mkEnableOption "Enable eww";

    battery = {
      enable = mkEnableOption "Tell eww to display battery status.";

      identifier = mkOption {
        type = types.str;
        default = "BAT0";
        description = "A string representing the identifier of the battery in your computer that you wish EWW to track. Check which battery you have by running the command `ls -X /sys/class/power_supply | grep 'BAT'` If the result is not `BAT0`, set this variable to what you see in your terminal.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
      eww
    ];
  };
}
