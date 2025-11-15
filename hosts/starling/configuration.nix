{ ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/starling
    ../../users/kent
  ];

  # Bootloader.
  boot = {
    kernelParams = [
      "fbcon=rotate:1"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "Starling";
    firewall.enable = true;
  };

  hardware.bluetooth.enable = true;

  stdenv.hostPlatform.system.stateVersion = "25.05";
}

