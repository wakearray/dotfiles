{ ... }:
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/delaware
    ../../users/kent
    ../../users/jess
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable networking.
  networking = {
    networkmanager.enable = true;
    hostName = "Delaware"; # Define your hostname
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  system.stateVersion = "24.11";
}
