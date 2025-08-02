{ lib, config, pkgs, ... }:
let
  cfg = config.gui.kiosk;
in
{
  options.gui.kiosk = with lib; {
    enable = mkOption {
      type = types.bool;
      default = config.modules.systemDetails.isKiosk;
      description = "Enable programs and settings specifically for kiosks.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # A way to use your phone to emulate a mouse and keyboard on a system
      remote-touchpad
    ];
  };
}
