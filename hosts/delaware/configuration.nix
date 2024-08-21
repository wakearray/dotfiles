{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let
  config.secrets = "/etc/nixos/secrets";
  config.domain = "voicelesscrimson.com";
in
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
    ../../modules/delaware
    ../../users/kent
    ../../users/jess
  ];

  # Bootloader.
  boot.loader = { 
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "Delaware"; # Define your hostname.

  # Enable networking.
  networking.networkmanager.enable = true;

  # When true, no X11 libraries will be installed on this machine.
  environment.noXlibs = true;
  
  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  system.stateVersion = "23.05";
}
