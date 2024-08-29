{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/OpenRGB
  # https://openrgb.org/index.html

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
  ];

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    # CPU type, intel, amd, or null
    motherboard = "intel";
    # 6742 is the default, but listed here to make
    # it easier to tell what port is being used.
    server.port = 6742;
  };
}
