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

  host-options = {
    display-system = "none";
    host-type = "server";
    hasPrinters = true;
  };

  # When true, no X11 libraries will be installed on this machine.
  # This needs to be false for deluge to install -_-
  environment.noXlibs = false;

  system.stateVersion = "23.05";
}
