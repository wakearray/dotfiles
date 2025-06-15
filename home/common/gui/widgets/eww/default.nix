{ lib, config, pkgs, ... }:
let
  isAndroid = config.home.systemDetails.isAndroid;
  isLaptop = config.home.systemDetails.isLaptop;
  gui = config.gui;
  eww = gui.eww;
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
      enable = mkOption {
        type = types.bool;
        default = (isAndroid || isLaptop);
        description = "Tell eww to display battery status. Defaults to `true` if `systemDetails.hostType` is either `laptop` or `android`";
      };

      identifier = mkOption {
        type = types.str;
        default = "BAT0";
        description = "A string representing the identifier of the battery in your computer that you wish EWW to track. Check which battery you have by running the command `ls -X /sys/class/power_supply | grep 'BAT'` If the result is not `BAT0`, set this variable to what you see in your terminal.";
      };

      monitorFrequency = mkOption {
        type = types.int;
        default = 5;
        description = "The amount of time, in seconds, to wait inbetween each check of the battery status. The lower the number, the more recent the battery% will be, but the more it will impact your battery life.";
      };
    };
  };
  config = lib.mkIf (gui.enable && eww.enable) {
    home.packages = [
      pkgs.playerctl
      pkgs.eww
    ];
  };
}
