{ pkgs, lib, config, ... }:
let
  cfg = config.gui.gaming;
in
{
  # This config is used to experiment with getting the 8bitdo Pro 2 controller working over bluetooth again
  config = lib.mkIf cfg.enable {
    #services.udev.extraRules = ''
    #  # 8BitDo Pro 2; Bluetooth; USB
    #  ACTION!="remove", SUBSYSTEM=="input", ATTRS{name}=="8BitDo Pro 2", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
    #  ACTION!="remove", SUBSYSTEM=="input", ATTR{id/vendor}=="2dc8", ATTR{id/product}=="6006", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
    #  ACTION!="remove", SUBSYSTEM=="input", ATTR{id/vendor}=="2dc8", ATTR{id/product}=="6003", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"

    #  # 8BitDo Pro 2 Wired; USB
    #  # X-mode uses the 8BitDo Generic Device rule
    #  # B-Mode
    #  ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="3010", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
    #  ACTION!="remove", SUBSYSTEMS=="input", ATTRS{id/product}=="3010", ATTRS{id/vendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
    #'';

    hardware.uinput.enable = true;

    services = {
      udev = {
        packages = with pkgs; [
          game-devices-udev-rules
        ];
      };
    };
  };
}
