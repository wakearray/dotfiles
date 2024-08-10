{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
{
  # Trying to prevent the fingerprint reader from blocking resume from suspend-to-ram
  # Only occasionally works
  boot.kernelParams = [ "drm_kms_helper.poll=N" "usbcore.autosuspend=-1" ];

  # Udev rule to disable the driverless fingerprint reader
  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0"
  '';
}
