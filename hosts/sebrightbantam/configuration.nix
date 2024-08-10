{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
    ../../modules/sebrightbantam
    ../../users/kent
  ];

  # System will only work with MBR and fails to find derivations to boot from with EFI.
  boot.loader.grub.device = "/dev/sdc";

  networking.hostName = "SebrightBantam"; # Define your hostname.

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  system.stateVersion = "24.05";
}
