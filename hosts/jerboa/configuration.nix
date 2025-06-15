{ ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/jerboa
    ../../users/kent
    ../../users/entertainment
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "Jerboa"; # TV computer
    networkmanager.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
  };

  system.stateVersion = "23.11";
}
