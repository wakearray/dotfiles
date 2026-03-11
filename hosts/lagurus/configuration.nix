{ ... }:
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/lagurus
    ../../users/kent
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "Lagurus";
    firewall.enable = true;
  };

  system.stateVersion = "23.11";
}
