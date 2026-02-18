{ ... }:
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/sebrightbantam
    ../../users/kent
  ];

  # This host will only boot with MBR and fails to boot with EFI.
  boot.loader.grub.device = "/dev/sdc";

  networking.hostName = "SebrightBantam"; # Define your hostname.

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  system.stateVersion = "24.05";
}
