{ lib, config, ... }:
let
  isAndroid = config.home.systemDetails.isAndroid;
  gui = config.gui;
  cfg = config.android.gui;
in
{
  # home/jess/common/android/gui
  # GUI progams and settings for all Android devices
  imports = [
    ./rofi.nix
  ];

  options.android.gui = with lib; {
    enable = mkOption {
      type = types.bool;
      default = (isAndroid && gui.enable);
      description = "Defaults to true if device is Android and systemDetails.display isn't `cli`.";
    };
  };

  config = lib.mkIf cfg.enable {
    gui = {
      wm.i3.enable = true;
      polybar.enable = true;
    };
  };
}
